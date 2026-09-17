; Build a Queue in Assembly - slide 6: enqueue, write at the tail, advance, wrap
; The slide's enqueue replaces the library's. Eight enqueues fill the ring (the tail wraps to 0), the
; ninth is refused.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYQUEUE_NO_ENQUEUE
%include "tinyqueue.inc"

start:
    tinyx86_init
    mov ebx, 10
.fill:
    mov eax, ebx
    call enqueue
    mov si, m_enq           ; enqueue N: tail T count C
    call puts
    mov eax, ebx
    call print_dec
    call show
    add ebx, 10
    cmp ebx, 80
    jle .fill
    mov eax, 90
    call enqueue            ; count == CAP: refused
    je .refused
    call halt
.refused:
    mov si, m_full          ; enqueue 90: refused, the queue is full
    call puts
    call halt

enqueue:                    ; EAX = value
    cmp dword [q.count], CAP
    je .full                ; no free slot: refuse
    mov ecx, [q.tail]
    mov [q.buf + ecx*4], eax    ; write at the tail
    inc ecx
    and ecx, CAP - 1        ; wrap: 7 + 1 = 8, 8 and 7 = 0
    mov [q.tail], ecx
    inc dword [q.count]     ; O(1): no element moved
    cmp ecx, -1             ; ZF = 0: stored
.full:
    ret                     ; ZF = 1 when refused: je right after the call

show:                       ; prints tail and count
    mov si, m_tail
    call puts
    mov eax, [q.tail]
    call print_dec
    mov si, m_count
    call puts
    mov eax, [q.count]
    call print_dec
    call newline
    ret

m_enq:   db "enqueue ", 0
m_tail:  db ": tail ", 0
m_count: db " count ", 0
m_full:  db "enqueue 90: refused, the queue is full", 0

tinyx86_lib
tinyqueue_lib
times 510-($-$$) db 0
dw 0xaa55
