#!/usr/bin/env bash
# Build an x86 Assembly Lab in 10 Minutes - slide 07: verify.sh
# Runs as is on Ubuntu 24.04 or WSL Ubuntu; check.sh only boots the .asm files, this one is for you.

nasm -v
# NASM version 2.16.01
qemu-system-i386 --version | head -n 1
# QEMU emulator version 8.2.2
make --version | head -n 1
# GNU Make 4.3
gdb --version | head -n 1
# GNU gdb (Ubuntu 15.0.50) 15.0.50
# four version lines: the lab is installed
