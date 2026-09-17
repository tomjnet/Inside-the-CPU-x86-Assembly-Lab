; Build a C Style Array in Assembly - slide 5: the array does not know its own size
; A sentinel dword sits right after the array, so numbers[5] reads 777: no error, just the next bytes.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    jmp code

numbers: dd 10, 20, 30, 40, 50
count equ ($ - numbers) / 4     ; 5, computed by NASM, stored nowhere
sentinel: dd 777                ; whatever happens to follow the array

code:
    mov si, m_count             ; count = 5
    call puts
    mov eax, count
    call print_dec
    call newline
; the array is 20 bytes; the CPU has no idea where it ends
mov eax, [numbers + 5*4]        ; numbers[5]: whatever follows the array
; C calls that undefined behaviour; the CPU just reads the next 4 bytes
    mov si, m_five              ; numbers[5] = 777
    call puts
    call print_dec
    call newline
; passing an array = passing a base address and a count, always both
mov esi, numbers                ; the address, like a C pointer
mov ecx, count                  ; the length travels separately
    mov si, m_pass              ; esi = 0x00007c.., ecx = 5
    call puts
    mov eax, esi
    call print_hex
    mov al, ' '
    call putc
    mov eax, ecx
    call print_dec
    call halt

m_count: db "count: ", 0
m_five:  db "numbers[5]: ", 0
m_pass:  db "esi ecx: ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
