; Loops, Conditions and Functions - slide 7: for (int i = 0; i < 10; i++)
; The body prints i, so the screen shows the ten trips: 0 1 2 3 4 5 6 7 8 9. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov si, m_i
    call puts

; C++:  for (int i = 0; i < 10; i++) { body }
    mov ecx, 0          ; i = 0
loop_start:
    cmp ecx, 10         ; i < 10 ?
    jge done            ; no: leave the loop (signed compare)
    ; body: ECX is i
    mov eax, ecx
    call print_dec
    mov al, ' '
    call putc
    inc ecx             ; i++
    jmp loop_start
done:
    mov si, m_done      ; ecx after the loop: 10
    call puts
    mov eax, ecx
    call print_dec
    call halt

m_i:    db "i: ", 0
m_done: db 13, 10, "ecx after the loop: ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
