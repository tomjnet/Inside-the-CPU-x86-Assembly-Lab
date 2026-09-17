; Build a Dynamic Array in Assembly - slide 2: from array to vector, three fields
; The slide's object is the one in lib/tinyvec.inc. Prints its three fields when empty and after five pushes.
bits 16
org 0x7c00
%include "tinyx86.inc"
%include "tinyvec.inc"

start:
    tinyx86_init
    call vec_init
    call show               ; data 0x00008000 size 0 cap 2
    mov eax, 10
    call vec_push
    mov eax, 20
    call vec_push
    mov eax, 30
    call vec_push
    mov eax, 40
    call vec_push
    mov eax, 50
    call vec_push
    call show               ; data 0x00008018 size 5 cap 8 (two grows moved the buffer)
    call halt

show:                       ; prints the three fields of the object
    mov si, m_data
    call puts
    mov eax, [vec.data]
    call print_hex
    mov si, m_size
    call puts
    mov eax, [vec.size]
    call print_dec
    mov si, m_cap
    call puts
    mov eax, [vec.cap]
    call print_dec
    call newline
    ret

; C++:  std::vector<int> numbers;     three fields, whatever their names
; vec:                        the object: 12 bytes, inside our sector
; .data:  dd 0                address of the first element (a pointer)
; .size:  dd 0                elements in use
; .cap:   dd 0                slots allocated
; the elements live somewhere else: a buffer of cap * 4 bytes
; vec.data -> [ 10 | 20 | 30 | 40 | 50 |   |   |   ]   size 5, cap 8

m_data: db "data ", 0
m_size: db " size ", 0
m_cap:  db " cap ", 0

tinyx86_lib
tinyvec_lib
times 510-($-$$) db 0
dw 0xaa55
