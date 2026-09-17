; Registers, Memory and the Stack - slide 7: memory, a value or an address
; Prints the value, the address, the value through the address, and the value after the write.
; The address line shows 0x00007cXX: wherever the four bytes of number landed inside our sector.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    jmp code                ; skip over the data: the CPU must not execute 4096 as an instruction

number: dd 4096         ; four bytes in memory holding 4096

code:
mov eax, [number]       ; EAX = 4096: the value stored at number
    mov si, m_val
    call puts
    call print_dec
    call newline
mov ebx, number         ; EBX = 0x7c..: the address of number
    mov si, m_addr
    call puts
    mov eax, ebx
    call print_hex
    call newline
mov ecx, [ebx]          ; ECX = 4096: the value at the address in EBX
    mov si, m_via
    call puts
    mov eax, ecx
    call print_dec
    call newline
; brackets = go to memory; no brackets = the number itself
mov dword [number], 7   ; write 7 into those four bytes
mov eax, [number]       ; EAX = 7 now
    mov si, m_after
    call puts
    call print_dec
    call halt

m_val:   db "[number]:          ", 0
m_addr:  db "number (address):  ", 0
m_via:   db "[ebx]:             ", 0
m_after: db "[number] after 7:  ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
