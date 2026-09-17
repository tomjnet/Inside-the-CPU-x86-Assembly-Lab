; Loops, Conditions and Functions - slide 6: test, cheap checks for zero and bits
; Classifies 0, 7 and 8 with the slide's two tests: zero, odd or even.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov eax, 0
    call classify           ; 0: zero
    mov eax, 7
    call classify           ; 7: odd
    mov eax, 8
    call classify           ; 8: even
    call halt

classify:                   ; prints EAX and whether it is zero, odd or even
    call print_dec
    mov si, m_sep
    call puts
test eax, eax           ; EAX AND EAX: ZF if EAX is zero, no change
jz  is_zero             ; the idiom for  if (x == 0)
test al, 1              ; looks at bit 0 only
jnz is_odd              ; bit 0 set: an odd number
; test is cmp for bits: an AND that keeps only the flags
    mov si, m_even
    jmp puts                ; puts returns to our caller
is_zero:
    mov si, m_zero
    jmp puts
is_odd:
    mov si, m_odd
    jmp puts

m_sep:  db ": ", 0
m_zero: db "zero", 13, 10, 0
m_odd:  db "odd", 13, 10, 0
m_even: db "even", 13, 10, 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
