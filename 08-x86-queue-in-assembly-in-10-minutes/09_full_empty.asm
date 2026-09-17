; Build a Queue in Assembly - slide 9: full and empty, why the count is there
; The slide's checks replace the library's. Empty at the start, full after eight enqueues, and head == tail
; in both cases: only the count tells them apart.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYQUEUE_NO_CHECKS
%include "tinyqueue.inc"

start:
    tinyx86_init
    mov si, m_start         ; start: head 0 tail 0
    call puts
    call show
    call is_empty
    jne .not_empty
    mov si, m_empty         ; is_empty: yes
    call puts
.not_empty:
    mov ebx, 8              ; ebx, not ecx: enqueue uses ecx for the tail
.fill:
    mov eax, ebx
    call enqueue
    dec ebx
    jnz .fill
    mov si, m_after         ; after 8 enqueues: head 0 tail 0
    call puts
    call show
    call is_full
    jne .not_full
    mov si, m_full          ; is_full: yes
    call puts
.not_full:
    call halt

show:                       ; prints head and tail
    mov si, m_head
    call puts
    mov eax, [q.head]
    call print_dec
    mov si, m_tail
    call puts
    mov eax, [q.tail]
    call print_dec
    call newline
    ret

; count answers both questions; head == tail alone cannot:
;   head == tail and count == 0     empty
;   head == tail and count == CAP   full
is_empty:
    cmp dword [q.count], 0
    ret                     ; ZF = 1 when empty: je right after the call
is_full:
    cmp dword [q.count], CAP
    ret                     ; ZF = 1 when full
; without count: keep one slot free, or store head and tail unwrapped

m_start: db "start:            ", 0
m_after: db "after 8 enqueues: ", 0
m_head:  db "head ", 0
m_tail:  db " tail ", 0
m_empty: db "is_empty: yes", 13, 10, 0
m_full:  db "is_full: yes", 13, 10, 0

tinyx86_lib
tinyqueue_lib
times 510-($-$$) db 0
dw 0xaa55
