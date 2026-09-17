; Build a C Style Array in Assembly - slide 6: linear search, O(n)
; Searches 40 (found at index 3) and 99 (not found, -1 printed as "not found"). make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov ebx, 40
    call search             ; index of 40: 3
    mov ebx, 99
    call search             ; index of 99: not found
    call halt

search:                     ; prints the index of EBX in numbers, or not found
    mov si, m_index
    call puts
    mov eax, ebx
    call print_dec
    mov si, m_is
    call puts
; find the index of EBX in numbers, or -1:  O(n)
    mov ecx, 0
find:
    cmp ecx, count              ; ran off the end?
    jge not_found
    cmp [numbers + ecx*4], ebx  ; numbers[i] == value ?
    je found                    ; ECX is the index
    inc ecx
    jmp find
found:
    mov eax, ecx
    call print_dec
    call newline
    ret
not_found:
    mov si, m_none
    call puts
    ret

numbers: dd 10, 20, 30, 40, 50
count equ ($ - numbers) / 4
m_index: db "index of ", 0
m_is:    db ": ", 0
m_none:  db "not found", 13, 10, 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
