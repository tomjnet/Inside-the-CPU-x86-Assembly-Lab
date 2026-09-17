; Assembly Language in 5 Minutes - slide 4: assembly source, assembler, machine code, cpu
; Not a boot sector: assemble it and compare the bytes NASM produced with the comments.
;   nasm -f bin 04_assembler.asm -o build/04_assembler.bin
;   ndisasm -b 16 build/04_assembler.bin         (or: make dump-04_assembler)
; NASM picks the shortest encoding: add ax, 5 becomes 83 C0 05 (sign extended 8 bit immediate),
; and the jump distance of je (02) is computed by the assembler, not by you.

bits 16                 ; source          machine code (NASM output)
mov ax, 10              ; AX = 10         B8 0A 00
add ax, 5               ; AX = 15         83 C0 05
cmp ax, 15              ; sets the flags  83 F8 0F
je done                 ; jump if equal   74 02  (2 bytes ahead)
jmp $                   ; loop forever    EB FE
done:
hlt                     ; stop the CPU    F4
