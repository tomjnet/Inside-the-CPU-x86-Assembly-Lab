; Loops, Conditions and Functions - slide 4: if (a == b), cmp, je and jne
; Runs the slide's if twice: once with a == b, once with a != b, and prints which branch ran.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    call check              ; a = 5, b = 5: then part
    mov dword [a], 9        ; now a != b
    call check              ; else part
    call halt

check:
; C++:  if (a == b) { then } else { else }
    mov eax, [a]
    cmp eax, [b]        ; flags from a - b
    jne not_equal       ; ZF = 0: jump over the then part
    ; then part: a == b
    mov si, m_then
    call puts
    jmp done
not_equal:
    ; else part: a != b
    mov si, m_else
    call puts
done:
; je jumps when ZF = 1, jne when ZF = 0: that is the whole if
    ret

a: dd 5
b: dd 5
m_then: db "a == b: the then part ran", 13, 10, 0
m_else: db "a != b: the else part ran", 13, 10, 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
