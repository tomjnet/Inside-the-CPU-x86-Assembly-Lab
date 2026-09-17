; Build a Queue in Assembly - slide 7: dequeue and front, read at the head, advance, wrap
; The slide's front and dequeue replace the library's (no empty check here: the program never
; dequeues an empty queue). Three enqueues, then front, dequeue, dequeue, front.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYQUEUE_NO_DEQUEUE
%include "tinyqueue.inc"

start:
    tinyx86_init
    mov eax, 10
    call enqueue
    mov eax, 20
    call enqueue
    mov eax, 30
    call enqueue
    mov si, m_front         ; front: 10
    call puts
    call front
    call print_dec
    call newline
    mov si, m_deq           ; dequeue: 10
    call puts
    call dequeue
    call print_dec
    call newline
    mov si, m_deq           ; dequeue: 20
    call puts
    call dequeue
    call print_dec
    call newline
    mov si, m_front         ; front: 30
    call puts
    call front
    call print_dec
    call newline
    mov si, m_state         ; head 2 count 1
    call puts
    mov eax, [q.head]
    call print_dec
    mov si, m_count
    call puts
    mov eax, [q.count]
    call print_dec
    call halt

front:                      ; EAX = the oldest element, kept
    mov ecx, [q.head]
    mov eax, [q.buf + ecx*4]
    ret                     ; O(1)
dequeue:                    ; EAX = the oldest element, removed
    call front
    inc dword [q.head]
    and dword [q.head], CAP - 1   ; wrap
    dec dword [q.count]
    ret                     ; O(1): head moved, the data did not

m_front: db "front:   ", 0
m_deq:   db "dequeue: ", 0
m_state: db "head ", 0
m_count: db " count ", 0

tinyx86_lib
tinyqueue_lib
times 510-($-$$) db 0
dw 0xaa55
