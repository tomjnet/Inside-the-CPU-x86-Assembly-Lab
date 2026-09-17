; Registers, Memory and the Stack - slide 6: mov, add, sub, inc, dec, the everyday set
; Prints the register after every instruction of the slide. make run-06_arith, make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

%macro show 2               ; show "label", register: prints label and the register in decimal
    push eax
    mov si, %1
    call puts
    mov eax, %2
    call print_dec
    call newline
    pop eax
%endmacro

start:
    tinyx86_init

mov eax, 100            ; EAX = 100
sub eax, 58             ; EAX = 42
    show m_sub, eax
inc eax                 ; EAX = 43
    show m_inc, eax
dec eax                 ; EAX = 42
    show m_dec, eax
mov ecx, eax            ; ECX = 42 (a copy)
add ecx, ecx            ; ECX = 84
    show m_ecx, ecx
xor edx, edx            ; EDX = 0: the idiom for "zero a register"
    show m_edx, edx
imul eax, 3             ; EAX = 126 (signed multiply)
; each line is one CPU instruction: one step, one register changed
    show m_imul, eax
    call halt

m_sub:  db "sub eax, 58:  eax = ", 0
m_inc:  db "inc eax:      eax = ", 0
m_dec:  db "dec eax:      eax = ", 0
m_ecx:  db "add ecx, ecx: ecx = ", 0
m_edx:  db "xor edx, edx: edx = ", 0
m_imul: db "imul eax, 3:  eax = ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
