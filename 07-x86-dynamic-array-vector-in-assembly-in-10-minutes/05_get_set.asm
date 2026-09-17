; Build a Dynamic Array in Assembly - slide 5: get and set, the array again through the pointer
; Three pushes, then get index 1, set index 1 to 99, get it again.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYVEC_NO_GET
%define TINYVEC_NO_SET
%include "tinyvec.inc"

start:
    tinyx86_init
    call vec_init
    mov eax, 10
    call vec_push
    mov eax, 20
    call vec_push
    mov eax, 30
    call vec_push
    mov si, m_get           ; get(1): 20
    call puts
    mov ecx, 1
    call vec_get
    call print_dec
    call newline
    mov ecx, 1
    mov eax, 99
    call vec_set            ; set(1, 99)
    mov si, m_after         ; get(1) after set(1, 99): 99
    call puts
    mov ecx, 1
    call vec_get
    call print_dec
    call halt

vec_get:                    ; ECX = index  ->  EAX = element
    mov ebx, [vec.data]     ; the buffer address, from the object
    mov eax, [ebx + ecx*4]  ; the array access of last episode
    ret                     ; O(1)
vec_set:                    ; ECX = index, EAX = value
    mov ebx, [vec.data]
    mov [ebx + ecx*4], eax
    ret                     ; O(1)
; the only difference from an array: one extra load, the pointer

m_get:   db "get(1): ", 0
m_after: db "get(1) after set(1, 99): ", 0

tinyx86_lib
tinyvec_lib
times 510-($-$$) db 0
dw 0xaa55
