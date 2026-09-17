#!/usr/bin/env bash
# My First Bare Metal x86 Program - slide 9: assemble and boot
# Runs as is from this folder on Ubuntu 24.04 or WSL Ubuntu (mkdir -p build first, or run make).

nasm -f bin 08_program.asm -o build/08_program.bin
qemu-system-i386 -cpu qemu32 \
    -drive format=raw,file=build/08_program.bin
# or, from the episode folder:
make run-08_program
# on the screen, after the BIOS banner:
#   Booting from Hard Disk...
#   TomJNET Community
