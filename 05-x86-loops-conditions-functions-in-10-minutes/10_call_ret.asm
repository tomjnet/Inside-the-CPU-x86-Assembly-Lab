; Loops, Conditions and Functions - slide 10: call and ret, the return address on the stack
; Prints sp before the call and inside the function (2 less: a 16 bit return address in real mode), then eax after ret.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov si, m_sp_before     ; sp before the call: 0x7c00
    call puts
    movzx eax, sp
    call print_hex
    call newline

    mov eax, 10
    mov ebx, 20
    call add_numbers    ; push the return address, jump to add_numbers
    ; EAX = 30 here: ret brought us back to this line
    mov si, m_eax           ; eax after ret: 30
    call puts
    call print_dec
    call halt

add_numbers:            ; a function: EAX = EAX + EBX
    add eax, ebx
    push eax                ; keep the result while we print sp
    mov si, m_sp_inside     ; sp inside the function: 0x7bfe (the 2 byte return address is on the stack)
    call puts
    movzx eax, sp
    add eax, 4              ; undo our own push so the value is the sp the call produced
    call print_hex
    call newline
    pop eax
    ret                 ; pop the return address into EIP

m_sp_before: db "sp before the call:     ", 0
m_sp_inside: db "sp inside add_numbers:  ", 0
m_eax:       db "eax after ret:          ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
