#!/usr/bin/env bash
# My First Bare Metal x86 Program - slide 11: read your bytes back with ndisasm
# Run make first so build/08_program.bin exists.

ndisasm -b 16 -o 0x7c00 build/08_program.bin | head -n 9
# 00007C00  BE107C     mov si,0x7c10     <- message, because of org
# 00007C03  AC         lodsb
# 00007C04  3C00       cmp al,0x0
# 00007C06  7406       jz 0x7c0e         <- ndisasm spells je as jz
# 00007C08  B40E       mov ah,0xe
# 00007C0A  CD10       int 0x10
# 00007C0C  EBF5       jmp short 0x7c03  <- back 11 bytes: F5 = -11
# 00007C0E  EBFE       jmp short 0x7c0e  <- jmp $: to itself
# 00007C10  54         push sp           <- 'T' = 0x54, read as code
