; Build a C Style Array in Assembly - slide 3: address = base + index times 4
; numbers[2] through a register index and numbers[4] through a constant one. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

; address = base + index * 4       (4 bytes per int)
mov ecx, 2                      ; index
mov eax, [numbers + ecx*4]      ; EAX = numbers[2] = 30
    mov si, m_two               ; numbers[2] = 30
    call puts
    call print_dec
    call newline
; the CPU computes numbers + 2*4 = numbers + 8 in the addressing mode
; scale can be 1, 2, 4 or 8:  [base + index*scale + offset]
mov eax, [numbers + 4*4]        ; a constant index: numbers[4] = 50
; one instruction, one memory read: O(1) for any index
    mov si, m_four              ; numbers[4] = 50
    call puts
    call print_dec
    call halt

numbers: dd 10, 20, 30, 40, 50
m_two:  db "numbers[2] = ", 0
m_four: db "numbers[4] = ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
