; Registers, Memory and the Stack - slide 10: the stack, push and pop
; Prints the stack pointer after every push and pop: it goes down by 4 twice, then back up.
; In real mode the CPU uses the 16 bit sp; movzx eax, sp lets print_hex show it.
bits 16
org 0x7c00
%include "tinyx86.inc"

%macro show_sp 1            ; prints label and sp; keeps every register
    push eax
    mov si, %1
    call puts
    movzx eax, sp
    add eax, 4              ; undo the push eax above so the value is the real sp
    call print_hex
    call newline
    pop eax
%endmacro

start:
    tinyx86_init
    show_sp m_start         ; sp = 0x7c00

mov eax, 10
mov ebx, 20
push eax                ; ESP = ESP - 4, [ESP] = 10
    show_sp m_push1         ; sp = 0x7bfc
push ebx                ; ESP = ESP - 4, [ESP] = 20   (20 is on top)
    show_sp m_push2         ; sp = 0x7bf8
    mov eax, 0              ; wipe both registers so the pops visibly restore them
    mov ebx, 0
pop ebx                 ; EBX = [ESP] = 20, ESP = ESP + 4
    show_sp m_pop1          ; sp = 0x7bfc
pop eax                 ; EAX = [ESP] = 10, ESP = ESP + 4
    show_sp m_pop2          ; sp = 0x7c00
; the stack grows down: push lowers ESP, pop raises it
; last in, first out: the last push is the first pop
    mov si, m_regs          ; eax 10 ebx 20
    call puts
    call print_dec
    mov al, ' '
    call putc
    mov eax, ebx
    call print_dec
    call halt

m_start: db "start:    sp = ", 0
m_push1: db "push eax: sp = ", 0
m_push2: db "push ebx: sp = ", 0
m_pop1:  db "pop ebx:  sp = ", 0
m_pop2:  db "pop eax:  sp = ", 0
m_regs:  db "eax ebx after the pops: ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
