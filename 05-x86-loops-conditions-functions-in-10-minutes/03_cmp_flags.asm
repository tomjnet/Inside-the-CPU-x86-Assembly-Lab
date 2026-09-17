; Loops, Conditions and Functions - slide 3: cmp and the flags ZF, SF, CF
; After the compare, lahf copies SF, ZF, AF, PF and CF into AH (bits 7, 6, 4, 2, 0) so we can print them.
; make run-03_cmp_flags, make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

mov eax, 5
mov ebx, 7
cmp eax, ebx            ; EAX - EBX = -2, keeps only the flags:
; ZF = 0  the result is not zero: not equal
; SF = 1  the result is negative: EAX < EBX as signed numbers
; CF = 1  a borrow happened: EAX < EBX as unsigned numbers
; EAX and EBX are unchanged; the next jump reads the flags
    lahf                    ; AH = the flags, right after the compare
    mov dl, ah              ; keep them in DL while we print
    xor ah, ah              ; AH was 0 (EAX = 5): put it back so EAX prints as 5
    mov si, m_regs          ; eax 5 ebx 7 (unchanged)
    call puts
    call print_dec
    mov al, ' '
    call putc
    mov eax, ebx
    call print_dec
    call newline
    mov si, m_zf
    call puts
    mov al, dl
    and al, 0x40            ; ZF is bit 6
    call print_bit
    mov si, m_sf
    call puts
    mov al, dl
    and al, 0x80            ; SF is bit 7
    call print_bit
    mov si, m_cf
    call puts
    mov al, dl
    and al, 0x01            ; CF is bit 0
    call print_bit
    call halt

print_bit:                  ; AL nonzero prints 1, zero prints 0
    test al, al
    jz .zero
    mov al, '1'
    jmp putc                ; putc returns to our caller
.zero:
    mov al, '0'
    jmp putc

m_regs: db "eax ebx after cmp: ", 0
m_zf:   db "ZF=", 0
m_sf:   db " SF=", 0
m_cf:   db " CF=", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
