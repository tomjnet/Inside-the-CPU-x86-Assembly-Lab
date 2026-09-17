; My First Bare Metal x86 Program - slide 6: the BIOS teletype, int 0x10 with AH = 0x0e
; Two characters, three instructions each, no loop yet. The screen shows "TJ" after the BIOS banner.

bits 16
org 0x7c00

start:
; BIOS video service: interrupt 0x10, function 0x0e = teletype output
mov ah, 0x0e            ; AH selects the function: 0x0e = print one char
mov al, 'T'             ; AL = the character (its ASCII code, 0x54)
int 0x10                ; interrupt 0x10: call the BIOS video services
mov al, 'J'             ; AH is still 0x0e
int 0x10                ; 'J' appears after the 'T': the cursor moved
; no OS, no printf: the BIOS is the only software already in the machine

done:   jmp $

times 510-($-$$) db 0
dw 0xaa55
