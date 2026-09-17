; Build a C Style Array in Assembly - slide 7: insert at the beginning, shift everything, O(n)
; The array has one spare slot after it; prints it before and after the insert. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov si, m_before        ; before: 10 20 30 40 50
    call puts
    mov edx, count
    call show

; insert 5 at index 0: shift every element one slot right, then write
    mov ecx, count - 1          ; start from the last element
shift:
    mov eax, [numbers + ecx*4]
    mov [numbers + ecx*4 + 4], eax  ; numbers[i+1] = numbers[i]
    dec ecx
    jns shift                   ; until i goes below 0
    mov dword [numbers], 5      ; the slot is free: O(n) for one insert

    mov si, m_after         ; after:  5 10 20 30 40 50
    call puts
    mov edx, count + 1
    call show
    call halt

show:                       ; prints the first EDX elements of numbers
    xor ecx, ecx
.next:
    mov eax, [numbers + ecx*4]
    call print_dec
    mov al, ' '
    call putc
    inc ecx
    cmp ecx, edx
    jl .next
    call newline
    ret

numbers: dd 10, 20, 30, 40, 50
count equ ($ - numbers) / 4
spare:   dd 0               ; room for one more element
m_before: db "before: ", 0
m_after:  db "after:  ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
