; Build a Dynamic Array in Assembly - slide 8: pop and the capacity that stays
; Three pushes (capacity grew to 4), one pop: size 2, cap still 4, and the popped slot still holds 30.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYVEC_NO_POP
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
    call vec_pop
    mov si, m_after         ; after pop: size 2 cap 4
    call puts
    mov eax, [vec.size]
    call print_dec
    mov si, m_cap
    call puts
    mov eax, [vec.cap]
    call print_dec
    call newline
    mov si, m_slot          ; the popped slot still holds: 30
    call puts
    mov ecx, 2
    call vec_get
    call print_dec
    call halt

vec_pop:                    ; removes the last element
    dec dword [vec.size]    ; size--: O(1), nothing moves, cap stays
    ret
; the slot still holds the old value; it is just no longer counted
; capacity never shrinks on its own: C++ needs shrink_to_fit for that
; clear() is size = 0: also O(1) for ints, and the buffer is kept

m_after: db "after pop: size ", 0
m_cap:   db " cap ", 0
m_slot:  db "the popped slot still holds: ", 0

tinyx86_lib
tinyvec_lib
times 510-($-$$) db 0
dw 0xaa55
