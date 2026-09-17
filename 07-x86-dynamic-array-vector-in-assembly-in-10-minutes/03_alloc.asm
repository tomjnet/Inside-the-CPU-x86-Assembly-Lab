; Build a Dynamic Array in Assembly - slide 3: a heap in four instructions, the bump allocator
; Two allocations: 8 bytes, then 16 bytes. Prints the address of each and where heap_top ends up.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYVEC_NO_ALLOC    ; the slide's alloc below replaces the library's
%include "tinyvec.inc"

start:
    tinyx86_init
    jmp code

heap_top_note:              ; the library defines heap_top; the slide's line is kept as a comment:
; heap_top: dd 0x8000         ; free memory starts right after our sector
alloc:                      ; EAX = bytes wanted  ->  EAX = address
    mov edx, [heap_top]     ; the next free address
    add [heap_top], eax     ; bump it: those bytes are taken now
    mov eax, edx
    ret
; a bump allocator: malloc in four instructions, and no free
; real allocators track sizes and reuse blocks; ours only grows

code:
    mov si, m_first         ; alloc(8):  0x00008000
    call puts
    mov eax, 8
    call alloc
    call print_hex
    call newline
    mov si, m_second        ; alloc(16): 0x00008008
    call puts
    mov eax, 16
    call alloc
    call print_hex
    call newline
    mov si, m_top           ; heap_top:  0x00008018
    call puts
    mov eax, [heap_top]
    call print_hex
    call halt

m_first:  db "alloc(8):  ", 0
m_second: db "alloc(16): ", 0
m_top:    db "heap_top:  ", 0

tinyx86_lib
tinyvec_lib
times 510-($-$$) db 0
dw 0xaa55
