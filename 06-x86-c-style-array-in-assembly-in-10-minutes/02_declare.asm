; Build a C Style Array in Assembly - slide 2: what is an array?
; Prints every element next to its address: five dwords, addresses 4 apart. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    jmp code

; C:   int numbers[5] = {10, 20, 30, 40, 50};
numbers: dd 10, 20, 30, 40, 50   ; five dwords, side by side in memory
; address      value
; numbers+0    10
; numbers+4    20
; numbers+8    30
; numbers+12   40
; numbers+16   50     contiguous: 20 bytes, nothing in between

code:
    xor ecx, ecx
.next:
    lea eax, [numbers + ecx*4]  ; the address of numbers[i]
    call print_hex
    mov si, m_sep
    call puts
    mov eax, [numbers + ecx*4]  ; the value stored there
    call print_dec
    call newline
    inc ecx
    cmp ecx, 5
    jl .next
    call halt

m_sep: db "  ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
