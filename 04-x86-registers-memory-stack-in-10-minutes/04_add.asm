; Registers, Memory and the Stack - slide 4: arithmetic, add eax, ebx
; Prints both registers before and after the add. make run-04_add, make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

mov eax, 10             ; EAX = 10
mov ebx, 20             ; EBX = 20
    call show               ; before: eax 10 ebx 20
add eax, ebx            ; EAX = EAX + EBX = 30, EBX still 20
; before: EAX = 10  EBX = 20
; after:  EAX = 30  EBX = 20
; add writes its result into the first operand, the destination
    call show               ; after: eax 30 ebx 20
    call halt

show:                       ; prints "eax N ebx M" without changing either register
    push eax
    mov si, m_eax
    call puts
    call print_dec
    mov si, m_ebx
    call puts
    mov eax, ebx
    call print_dec
    call newline
    pop eax
    ret

m_eax: db "eax ", 0
m_ebx: db " ebx ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
