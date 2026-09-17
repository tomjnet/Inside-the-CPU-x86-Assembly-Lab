; Loops, Conditions and Functions - slide 9: loop and the counter in ECX
; The first loop prints ECX on every trip (5 4 3 2 1); the second counts its trips in EDX (5).
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov si, m_loop
    call puts

    mov ecx, 5          ; the counter register: ECX
repeat:
    ; body: runs 5 times, with ECX = 5, 4, 3, 2, 1
    mov eax, ecx
    call print_dec
    mov al, ' '
    call putc
    loop repeat         ; ECX = ECX - 1; jump if ECX != 0
; the same thing spelled out:
    mov si, m_again
    call puts
    xor edx, edx            ; trips counted here
    mov ecx, 5
again:
    inc edx
    dec ecx             ; ECX = ECX - 1, sets ZF when it reaches 0
    jnz again           ; jump if not zero
; ECX is why compilers love to count down: one instruction less
    mov eax, edx
    call print_dec
    call halt

m_loop:  db "loop:      ecx = ", 0
m_again: db 13, 10, "dec + jnz: trips = ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
