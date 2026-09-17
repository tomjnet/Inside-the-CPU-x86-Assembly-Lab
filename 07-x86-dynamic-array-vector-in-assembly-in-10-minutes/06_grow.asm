; Build a Dynamic Array in Assembly - slide 6: size equals capacity, grow
; Fills the capacity of 2, prints the object, pushes once more (the slide's vec_grow runs), prints again:
; the data pointer moved, capacity doubled, the elements were copied.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYVEC_NO_GROW
%include "tinyvec.inc"

start:
    tinyx86_init
    call vec_init
    mov eax, 10
    call vec_push
    mov eax, 20
    call vec_push
    mov si, m_full          ; full:       data 0x00008000 size 2 cap 2: 10 20
    call puts
    call show
    mov eax, 30
    call vec_push           ; size == cap: vec_grow, then the push
    mov si, m_grown         ; after grow: data 0x00008008 size 3 cap 4: 10 20 30
    call puts
    call show
    call halt

vec_grow:                   ; capacity doubles, the elements move
    mov eax, [vec.cap]
    add eax, eax            ; new capacity = 2 * cap
    mov [vec.cap], eax
    shl eax, 2              ; bytes = new capacity * 4
    call alloc              ; EAX = the new buffer
    mov si, [vec.data]      ; copy size elements, old -> new: O(n)
    mov di, ax
    mov cx, [vec.size]
    rep movsd               ; one dword per element, once per doubling
    mov [vec.data], eax     ; the object points at the new buffer now
    ret                     ; the old buffer is abandoned: no free

show:                       ; prints data, size, cap and the elements
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

m_full:  db "full:       ", 0
m_grown: db "after grow: ", 0
m_data:  db "data ", 0
m_size:  db " size ", 0
m_cap:   db " cap ", 0
m_colon: db ": ", 0

tinyx86_lib
tinyvec_lib
times 510-($-$$) db 0
dw 0xaa55
