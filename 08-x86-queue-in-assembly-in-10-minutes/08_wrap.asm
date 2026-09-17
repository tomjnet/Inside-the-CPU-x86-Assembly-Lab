; Build a Queue in Assembly - slide 8: wrap around, one AND when the capacity is a power of two
; Both forms of the wrap applied to index 7 (they give 0) and to index 3 (they give 4).
bits 16
org 0x7c00
%include "tinyx86.inc"
%include "tinyqueue.inc"    ; only for CAP

start:
    tinyx86_init
    mov ecx, 7
    call both               ; 7: and 0, cmp 0
    mov ecx, 3
    call both               ; 3: and 4, cmp 4
    call halt

both:                       ; prints ECX, then the next index by each method
    push ecx
    mov eax, ecx
    call print_dec
    mov si, m_and
    call puts
    call next_and
    mov eax, ecx
    call print_dec
    pop ecx
    mov si, m_cmp
    call puts
    call next_cmp
    mov eax, ecx
    call print_dec
    call newline
    ret

next_and:
; the ring: after slot 7 comes slot 0
    inc ecx                 ; 7 -> 8
    and ecx, CAP - 1        ; 8 and 7 = 0: back to the start, one AND
    ret
next_cmp:
; the same wrap for any capacity, three instructions and a branch:
    inc ecx
    cmp ecx, CAP
    jne .ok
    xor ecx, ecx            ; ecx = 0
.ok:
; that is why ring buffers love powers of two
    ret

m_and: db ": and ", 0
m_cmp: db ", cmp ", 0

tinyx86_lib
tinyqueue_lib
times 510-($-$$) db 0
dw 0xaa55
