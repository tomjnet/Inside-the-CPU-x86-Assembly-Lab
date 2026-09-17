#!/usr/bin/env bash
# Build an x86 Assembly Lab in 10 Minutes - slide 06: install.sh
# Runs as is on Ubuntu 24.04 or WSL Ubuntu; check.sh only boots the .asm files, this one is for you.

# Ubuntu 24.04, or Ubuntu inside WSL on Windows
sudo apt update
sudo apt install nasm qemu-system-x86 make binutils gdb
# nasm             the assembler (Intel syntax) and ndisasm, its reverse
# qemu-system-x86  the virtual PC: qemu-system-i386, our 32 bit machine
# make             one command to assemble, run and check
# binutils         objdump and friends, for looking at bytes
# gdb              the debugger, for when a program does nothing
