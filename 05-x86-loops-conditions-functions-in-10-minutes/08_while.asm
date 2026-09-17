; Loops, Conditions and Functions - slide 8: while and do-while, where the check goes
; The while loop of the slide sums 1 to 10 (55), then the same sum as a do-while with the test at the bottom.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

; C++:  while (n != 0) { sum += n; n--; }     the sum of 1 to 10
    mov eax, 0          ; sum
    mov ecx, 10         ; n
while_check:
    test ecx, ecx       ; n != 0 ?
    jz  while_done      ; check at the top: body may run 0 times
    add eax, ecx        ; sum += n
    dec ecx             ; n--
    jmp while_check
while_done:             ; EAX = 55
; a do-while puts the compare at the bottom: one jump per iteration
    mov si, m_while
    call puts
    call print_dec
    call newline

    mov eax, 0              ; the same sum as a do-while
    mov ecx, 10
do_body:
    add eax, ecx            ; the body runs first
    dec ecx
    jnz do_body             ; then the test, at the bottom: one jump per trip
    mov si, m_do
    call puts
    call print_dec
    call halt

m_while: db "while, sum of 1 to 10: ", 0
m_do:    db "do-while, same sum:    ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
