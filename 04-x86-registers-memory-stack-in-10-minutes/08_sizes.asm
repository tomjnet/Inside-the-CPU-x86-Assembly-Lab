; Registers, Memory and the Stack - slide 8: sizes, db, dw, dd, and byte, word, dword
; Reads one, two and four bytes into al, ax and eax, then writes with the size keywords and reads back.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    jmp code                ; the data sits before the code on the slide; jump over it

b: db 0x11              ; 1 byte
w: dw 0x2222            ; 2 bytes: a word
d: dd 0x33333333        ; 4 bytes: a double word

code:
    xor eax, eax            ; clear eax so the byte and word reads show up alone
mov al, [b]             ; AL  = 0x11:       8 bits from memory
    mov si, m_al
    call puts
    call print_hex
    call newline
mov ax, [w]             ; AX  = 0x2222:     16 bits
    mov si, m_ax
    call puts
    call print_hex
    call newline
mov eax, [d]            ; EAX = 0x33333333: 32 bits
    mov si, m_eax
    call puts
    call print_hex
    call newline
mov byte [b], 1         ; a write needs a size: no register here
mov word [w], 2
mov dword [d], 3        ; register or keyword: how many bytes
    mov si, m_back
    call puts
    movzx eax, byte [b]
    call print_dec
    movzx eax, word [w]
    call print_dec
    mov eax, [d]
    call print_dec
    call halt

m_al:   db "al  = [b]: ", 0
m_ax:   db "ax  = [w]: ", 0
m_eax:  db "eax = [d]: ", 0
m_back: db "after the writes, b w d: ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
