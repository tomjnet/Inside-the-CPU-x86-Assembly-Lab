; Registers, Memory and the Stack - slide 3: one register, four names: eax, ax, ah, al
; Prints eax after each write so the screen shows which bytes changed. make run-03_eax_parts, make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

mov eax, 0x12345678     ; EAX: 32 bits
; AX = the low 16 bits of EAX = 0x5678
; AH = the high byte of AX    = 0x56
; AL = the low byte of AX     = 0x78
    mov si, m_eax           ; eax: 0x12345678
    call puts
    call print_hex
    call newline
    mov si, m_ax            ; ax: 0x00005678  (the low 16 bits, zero extended to print)
    call puts
    push eax
    movzx eax, ax
    call print_hex
    pop eax
    call newline
mov al, 0x0e            ; only the low byte changes: EAX = 0x1234560e
    mov si, m_al            ; after mov al: 0x1234560e
    call puts
    call print_hex
    call newline
mov ah, 0x0e            ; episode 3: AH picked the BIOS function
; EBX, ECX and EDX split the same way: BX, BH, BL, and so on
    mov si, m_ah            ; after mov ah: 0x12340e0e
    call puts
    call print_hex
    call halt

m_eax: db "eax: ", 0
m_ax:  db "ax:  ", 0
m_al:  db "after mov al, 0x0e: ", 0
m_ah:  db "after mov ah, 0x0e: ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
