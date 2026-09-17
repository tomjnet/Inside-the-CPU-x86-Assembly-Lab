; Registers, Memory and the Stack - slide 9: little endian, how 0x12345678 sits in memory
; Prints the four bytes one by one at rising addresses, then the whole value. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    jmp code

value: dd 0x12345678    ; four bytes in memory, lowest byte first
; address:  value   value+1  value+2  value+3
; byte:      0x78     0x56     0x34     0x12

code:
    mov si, m_bytes         ; bytes at value, value+1, value+2, value+3:
    call puts
    xor ecx, ecx
.next:
    movzx eax, byte [value + ecx]
    call print_hex          ; 0x00000078 0x00000056 0x00000034 0x00000012
    mov al, ' '
    call putc
    inc ecx
    cmp ecx, 4
    jne .next
    call newline
mov al, [value]         ; AL = 0x78: low byte at the low address
mov al, [value + 3]     ; AL = 0x12: high byte at the highest one
mov eax, [value]        ; EAX = 0x12345678: the CPU puts the order back
; little endian: x86 stores the least significant byte first
    mov si, m_eax
    call puts
    call print_hex
    call halt

m_bytes: db "bytes at value+0..3: ", 0
m_eax:   db "eax = [value]:       ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
