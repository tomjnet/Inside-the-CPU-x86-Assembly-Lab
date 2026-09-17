; Registers, Memory and the Stack - slide 11: last in, first out, why the order matters
; push 1, push 2, pop into eax, pop into ebx: the registers come back swapped. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

mov eax, 1
mov ebx, 2
push eax                ; stack: 1
push ebx                ; stack: 1 2    (2 on top)
pop eax                 ; EAX = 2: the top comes off first
pop ebx                 ; EBX = 1
; the two registers swapped: last in, first out
; in real mode the pointer is the 16 bit SP; ESP is its 32 bit name
; our stack starts at 0x7c00 and grows down, just below our own code
    mov si, m_eax           ; eax = 2
    call puts
    call print_dec
    call newline
    mov si, m_ebx           ; ebx = 1
    call puts
    mov eax, ebx
    call print_dec
    call halt

m_eax: db "eax = ", 0
m_ebx: db "ebx = ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
