; Registers, Memory and the Stack - slide 5: the lab helpers, seeing a register
; The slide's program as is: the smallest use of lib/tinyx86.inc. make run-05_helpers, make check.
bits 16
org 0x7c00

%include "tinyx86.inc"  ; the lab helpers, built from episode 3
start:
    tinyx86_init        ; segments to 0, stack just under 0x7c00
    mov eax, 30
    call print_dec      ; prints EAX in decimal:  30
    call newline
    call print_hex      ; prints EAX as hex:  0x0000001e
    call halt           ; stop for good
tinyx86_lib             ; expands the routines after your code

times 510-($-$$) db 0
dw 0xaa55
