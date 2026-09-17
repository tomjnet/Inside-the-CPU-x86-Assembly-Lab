; Loops, Conditions and Functions - slide 11: arguments and results in registers
; max(7, 42) then max(42, 3): the result of the first call is the first argument of the second.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
; our lab's convention: arguments in EAX and EBX, result in EAX
    mov eax, 7
    mov ebx, 42
    call max            ; EAX = 42
    mov si, m_first         ; max(7, 42) = 42
    call puts
    call print_dec
    call newline
    mov ebx, 3
    call max            ; EAX = 42 again: the result feeds the next call
    mov si, m_second        ; max(42, 3) = 42
    call puts
    call print_dec
    call halt
max:                    ; EAX = the larger of EAX and EBX
    cmp eax, ebx
    jge .keep           ; EAX >= EBX: keep it
    mov eax, ebx        ; else take EBX
.keep:
    ret

m_first:  db "max(7, 42)  = ", 0
m_second: db "max(42, 3)  = ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
