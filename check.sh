#!/usr/bin/env bash
# Headless check of one samples folder: assemble every .asm with NASM, boot each 512 byte sector in QEMU
# with no window, read the VGA text screen through the QEMU monitor and compare it with <name>.expected
# (every non-empty line of the expected file must appear on screen, in that order). A sample that is not a
# boot sector (no 0xaa55 signature) is disassembled with ndisasm instead and compared the same way.
#
#   bash check.sh 03-x86-first-bare-metal-program-in-10-minutes      (from this folder)
#   WAIT=5 bash check.sh <folder>                                    (seconds the program gets to print)
#
# Prints one PASS/FAIL line per sample. Needs nasm, ndisasm, qemu-system-i386 and python3.
set -u

if [ $# -lt 1 ] || [ ! -d "$1" ]; then
  echo "usage: $0 <samples folder>" >&2
  exit 2
fi
here="$(cd "$(dirname "$0")" && pwd)"
folder="$(cd "$1" && pwd)"
wait_s="${WAIT:-3}"
qemu="${QEMU:-qemu-system-i386}"
for tool in nasm ndisasm "$qemu" python3; do
  command -v "$tool" >/dev/null 2>&1 || { echo "FAIL  tool not found: $tool"; exit 4; }
done

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# the VGA text buffer: 80 x 25 cells of (character, attribute); the monitor prints "addr: 0x.. 0x.." lines
decode='
import re, sys
cells = []
for m in re.finditer(r"^[0-9a-f]+:((?: 0x[0-9a-f]{2})+)", sys.stdin.read(), re.M):
    cells += [int(b, 16) for b in m.group(1).split()]
chars = bytes(cells[0::2][:2000]).decode("cp437", "replace")
print("\n".join(chars[i:i + 80].rstrip() for i in range(0, len(chars), 80)))
'

pass=0
fail=0
cd "$folder" || exit 2
for src in $(ls *.asm 2>/dev/null | sort); do
  name="${src%.asm}"
  bin="$work/$name.bin"
  if ! nasm -f bin -I "$here/lib/" "$src" -o "$bin" >"$work/$name.build" 2>&1; then
    fail=$((fail + 1))
    printf 'FAIL  %-44s build\n' "$name"
    head -n 10 "$work/$name.build" | sed 's/^/      | /'
    continue
  fi
  size=$(stat -c %s "$bin")
  sig=$(tail -c 2 "$bin" | od -An -tx1 | tr -d ' \n')
  if [ "$size" -eq 512 ] && [ "$sig" = "55aa" ]; then
    kind="screen"
    (sleep "$wait_s"; echo "xp /4000xb 0xb8000"; echo quit) \
      | timeout $((wait_s + 20)) "$qemu" -cpu qemu32 -display none -monitor stdio -no-reboot \
        -drive format=raw,file="$bin" >"$work/$name.mon" 2>&1
    python3 -c "$decode" <"$work/$name.mon" >"$work/$name.out"
  else
    kind="ndisasm"
    ndisasm -b 16 "$bin" >"$work/$name.out" 2>&1
  fi
  if [ ! -f "$name.expected" ]; then
    fail=$((fail + 1))
    printf 'FAIL  %-44s no %s.expected\n' "$name" "$name"
    continue
  fi
  missing=""
  from=1
  while IFS= read -r want || [ -n "$want" ]; do
    [ -z "$want" ] && continue
    hit=$(tail -n +"$from" "$work/$name.out" | grep -n -F -m 1 -- "$want" | cut -d: -f1)
    if [ -z "$hit" ]; then missing="$want"; break; fi
    from=$((from + hit))
  done <"$name.expected"
  if [ -z "$missing" ]; then
    pass=$((pass + 1))
    printf 'PASS  %-44s %s, %s lines\n' "$name" "$kind" "$(grep -c . "$work/$name.out")"
  else
    fail=$((fail + 1))
    printf 'FAIL  %-44s expected line not found: %s\n' "$name" "$missing"
    grep -v '^\(SeaBIOS\|iPXE\|Booting from\)' "$work/$name.out" | grep . | tail -n 12 | sed 's/^/      | /'
  fi
done

echo "----"
echo "$pass passed, $fail failed  (nasm $(nasm -v | awk '{print $3}'), $qemu)"
[ "$fail" -eq 0 ]
