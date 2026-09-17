; Build a Dynamic Array in Assembly - slide 4: push when there is room, O(1)
; The slide's vec_push replaces the library's. Two pushes into a capacity of 2: no grow happens.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYVEC_NO_PUSH
%include "tinyvec.inc"

start:
    tinyx86_init
    call vec_init
    mov eax, 10
    call vec_push
    call show               ; size 1 cap 2: 10
    mov eax, 20
    call vec_push
    call show               ; size 2 cap 2: 10 20
    call halt

vec_push:                   ; EAX = value
    mov ecx, [vec.size]
    cmp ecx, [vec.cap]
    je .grow                ; no room: next slides
    mov ebx, [vec.data]
    mov [ebx + ecx*4], eax  ; data[size] = value, at data + size*4
    inc dword [vec.size]    ; size++
    ret                     ; O(1): one write, one increment
.grow:
    push eax                ; slide 6: double the buffer, then push again
    call vec_grow
    pop eax
    jmp vec_push

show:                       ; prints size, cap and the elements
    mov si, m_size
    call puts
    mov eax, [vec.size]
    call print_dec
    mov si, m_cap
    call puts
    mov eax, [vec.cap]
    call print_dec
    mov si, m_colon
    call puts
    xor ecx, ecx
.next:
    cmp ecx, [vec.size]
    jge .done
    call vec_get
    call print_dec
    mov al, ' '
    call putc
    inc ecx
    jmp .next
.done:
    call newline
    ret

m_size:  db "size ", 0
m_cap:   db " cap ", 0
m_colon: db ": ", 0

tinyx86_lib
tinyvec_lib
times 510-($-$$) db 0
dw 0xaa55
