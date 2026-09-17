; Build a Dynamic Array in Assembly - slide 11: push_back can move everything, dangling pointers
; Takes a pointer to element 0, fills the vector past its capacity (a grow), sets element 0 to 99, then
; reads through the old pointer (stale 10) and through a fresh one (99).
bits 16
org 0x7c00
%include "tinyx86.inc"
%include "tinyvec.inc"

start:
    tinyx86_init
    call vec_init
    mov eax, 10
    call vec_push
    mov ebx, [vec.data]     ; a pointer into the buffer: &v[0] in C++
    push ebx                ; keep it: vec_push clobbers ebx
    ; ... push until the vector is full, then once more: vec_grow ...
    mov eax, 20
    call vec_push
    mov eax, 30
    call vec_push           ; size == cap: the buffer moves
    mov ecx, 0
    mov eax, 99
    call vec_set            ; v[0] = 99 in the live buffer
    pop ebx
    mov si, m_old           ; through the old pointer: 10
    call puts
    mov eax, [ebx]          ; reads the OLD buffer: stale, or garbage
    call print_dec
    call newline
    mov si, m_new           ; through a fresh pointer: 99
    call puts
    mov ebx, [vec.data]     ; take the pointer again after a grow
    mov eax, [ebx]          ; the live element
    call print_dec
    call halt
; this is C++ iterator invalidation: push_back may move every element
; every pointer, reference or iterator into the old buffer is dead
; a vector that never grows (reserve first) never invalidates

m_old: db "through the old pointer: ", 0
m_new: db "through a fresh pointer: ", 0

tinyx86_lib
tinyvec_lib
times 510-($-$$) db 0
dw 0xaa55
