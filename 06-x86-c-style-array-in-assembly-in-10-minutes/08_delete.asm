; Build a C Style Array in Assembly - slide 8: delete at the beginning O(n), at the end O(1)
; Deletes index 0 (everything shifts left), then deletes the last element (only len changes). make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov si, m_before        ; before:         10 20 30 40 50  len 5
    call puts
    call show

; delete index 0: shift every element one slot left, len - 1   O(n)
    mov edx, [len]              ; len: dd 5, the live count, in memory
    dec edx                     ; the last index
    mov ecx, 0
close:
    mov eax, [numbers + ecx*4 + 4]  ; numbers[i] = numbers[i+1]
    mov [numbers + ecx*4], eax
    inc ecx
    cmp ecx, edx
    jl close
    mov [len], edx              ; one element fewer
; delete the last element: just len = len - 1, nothing moves     O(1)
    mov si, m_front         ; delete index 0: 20 30 40 50  len 4
    call puts
    call show

    dec dword [len]         ; delete the last element: nothing moves
    mov si, m_back          ; delete the last: 20 30 40  len 3
    call puts
    call show
    call halt

show:                       ; prints the live elements of numbers and len
    xor ecx, ecx
.next:
    cmp ecx, [len]
    jge .done
    mov eax, [numbers + ecx*4]
    call print_dec
    mov al, ' '
    call putc
    inc ecx
    jmp .next
.done:
    mov si, m_len
    call puts
    mov eax, [len]
    call print_dec
    call newline
    ret

numbers: dd 10, 20, 30, 40, 50
len:     dd 5
m_before: db "before:          ", 0
m_front:  db "delete index 0:  ", 0
m_back:   db "delete the last: ", 0
m_len:    db " len ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
