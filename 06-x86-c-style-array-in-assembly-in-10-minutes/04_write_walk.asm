; Build a C Style Array in Assembly - slide 4: write and walk, the same address on both sides
; numbers[3] = 99, then the for loop prints every element: 10 20 30 99 50. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

mov dword [numbers + 3*4], 99   ; numbers[3] = 99: a write, same address
mov ecx, 0                      ; for (i = 0; i < 5; i++)
walk:
    mov eax, [numbers + ecx*4]  ; numbers[i]
    call print_dec              ; 10 20 30 99 50
    mov al, ' '
    call putc
    inc ecx
    cmp ecx, 5
    jl walk
; index in a register, base in the instruction: every C array loop
    call halt

numbers: dd 10, 20, 30, 40, 50

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
