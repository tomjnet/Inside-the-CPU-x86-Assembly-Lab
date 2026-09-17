#!/usr/bin/env bash
# Build an x86 Assembly Lab in 10 Minutes - slide 11: run it, nasm then qemu
# Runs as is on Ubuntu 24.04 or WSL Ubuntu; check.sh only boots the .asm files, this one is for you.

nasm -f bin 10_boot_smoke.asm -o build/10_boot_smoke.bin
ls -l build/10_boot_smoke.bin       # 512 bytes, always
BIN=build/10_boot_smoke.bin
qemu-system-i386 -cpu qemu32 -drive format=raw,file=$BIN
# -cpu qemu32          a generic 32 bit x86 CPU
# -drive format=raw    the file is the disk, byte for byte, sector 0
# same thing:  make run-10_boot_smoke
qemu-system-i386 -cpu qemu32 -display none -monitor stdio \
    -drive format=raw,file=$BIN     # headless, for scripts and check.sh
