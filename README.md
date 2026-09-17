# Inside the CPU: x86 Assembly Lab

Runnable code from the [Inside the CPU: x86 Assembly Lab](https://www.youtube.com/@TomJNet) video series, in English and Spanish.
One folder per episode, one NASM source per idea shown on the slides. Almost every sample is a 512 byte boot sector: QEMU loads it at `0x7c00` and runs it with no operating system underneath, which is the whole point of the series.

| Folder | Video |
|---|---|
| `01-x86-assembly-history-in-5-minutes` | Assembly Language in 5 Minutes: From Machine Code to Modern CPUs. The slide snippets as assembled files: the bytes NASM produces for each instruction, shown with ndisasm. |
| `02-x86-assembly-lab-nasm-qemu-in-10-minutes` | Build an x86 Assembly Lab in 10 Minutes: NASM + QEMU. The install, verify and run scripts, the Intel syntax example as a bootable program, and the smallest boot sector. |
| `03-x86-first-bare-metal-program-in-10-minutes` | My First Bare Metal x86 Program: Hello TomJNET Community. The skeleton, the message, the BIOS teletype, the loop and the whole program as bootable sectors, plus the run and ndisasm scripts. |
| `04-x86-registers-memory-stack-in-10-minutes` | Registers, Memory and the Stack in 10 Minutes. The slide snippets as bootable programs: every register printed on screen with the lab helpers. |
| `05-x86-loops-conditions-functions-in-10-minutes` | Loops, Conditions and Functions in x86 Assembly. The slide snippets as bootable programs: flags, jumps, three loops and two functions, results printed on screen. |
| `06-x86-c-style-array-in-assembly-in-10-minutes` | Build a C Style Array in Assembly: Data Structures + Big O. The slide snippets as bootable programs: index access, search, insert, delete and the sum, every array printed on screen. |
| `07-x86-dynamic-array-vector-in-assembly-in-10-minutes` | Build a Dynamic Array or C++ vector in Assembly: Data Structures + Big O. The slide snippets as bootable programs over lib/tinyvec.inc: the allocator, push, get, set, grow, pop and the dangling pointer, with size and capacity printed after every call. |
| `08-x86-queue-in-assembly-in-10-minutes` | Build a Queue in Assembly: Data Structures + Big O. The slide snippets as bootable programs over lib/tinyqueue.inc: the naive shift, the ring, enqueue, dequeue, the wrap and the full and empty checks, with head, tail and count printed. |
| `09-x86-assembly-series-summary-in-3-minutes` | Inside the CPU: What We Built in x86 Assembly. One capstone sector that boots every helper of the series: the screen routines, the vector and the queue. |

## The lab

- CPU: 32 bit x86 (`qemu32`), programs in 16 bit real mode, Intel syntax, assembled with NASM, run in QEMU.
- `lib/tinyx86.inc`: the helpers every sample from episode 4 on uses to show a register on screen (`puts`, `print_dec`, `print_hex`, `newline`, `halt`), written with the instructions of the series and the BIOS teletype service (`int 0x10`).
- `lib/tinyvec.inc`: episode 7's dynamic array (the object, a bump allocator at `0x8000`, `vec_push`, `vec_grow`, `vec_get`, `vec_set`, `vec_pop`), so each sample of that episode can show one routine and borrow the rest.
- `lib/tinyqueue.inc`: episode 8's circular queue (a ring of 8 dwords, `head`, `tail`, `count`, `enqueue`, `dequeue`, `front`, `is_empty`, `is_full`), used the same way.
- `check.sh`: assembles every sample of one folder, boots it with no window and compares the VGA text screen with `<name>.expected`.

## Build and run

Ubuntu or WSL Ubuntu:

```bash
sudo apt update
sudo apt install nasm qemu-system-x86 make binutils gdb
```

Every folder has the same Makefile:

```bash
cd 03-x86-first-bare-metal-program-in-10-minutes
make                 # assemble every sample into build/
make run-03_hello    # boot one sample in the QEMU window
make dump-03_hello   # disassemble one sample: the bytes the CPU sees
make check           # boot every sample headless and compare the screen with <name>.expected
make clean
```

## License

MIT
