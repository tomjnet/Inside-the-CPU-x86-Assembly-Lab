; Loops, Conditions and Functions - slide 5: signed and unsigned jumps, jl, jg, jb, ja
; The same compare, two jumps: jl (signed) is taken, jb (unsigned) is not. Each path prints its verdict.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

mov eax, -1             ; 0xffffffff: -1 signed, 4294967295 unsigned
mov ebx, 1
cmp eax, ebx            ; the same flags for both jumps below
jl  smaller_signed      ; taken: -1 < 1 as signed  (jl, jg, jle, jge)
    mov si, m_jl_no         ; never printed
    call puts
    jmp unsigned_test
smaller_signed:
    mov si, m_jl_yes        ; jl: taken, -1 is less than 1 as signed
    call puts
unsigned_test:
    cmp eax, ebx            ; the flags again (puts changed them)
jb  smaller_unsigned    ; not taken: 0xffffffff > 1 unsigned (jb, ja)
    mov si, m_jb_no         ; jb: not taken, 0xffffffff is above 1 as unsigned
    call puts
    call halt
; signed jumps read SF and OF, unsigned jumps read CF
; the bits are the same; the jump you pick decides what they mean
smaller_unsigned:
    mov si, m_jb_yes        ; never printed
    call puts
    call halt

m_jl_yes: db "jl: taken, -1 is less than 1 as signed", 13, 10, 0
m_jl_no:  db "jl: not taken", 13, 10, 0
m_jb_yes: db "jb: taken", 13, 10, 0
m_jb_no:  db "jb: not taken, 0xffffffff is above 1 as unsigned", 13, 10, 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
