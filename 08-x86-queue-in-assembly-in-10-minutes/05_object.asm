; Build a Queue in Assembly - slide 5: the object, a ring, a head, a tail and a count
; The slide's object replaces the library's. Prints head, tail and count when empty and after three enqueues.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYQUEUE_NO_OBJECT
%include "tinyqueue.inc"

start:
    tinyx86_init
    call show               ; head 0 tail 0 count 0
    mov eax, 10
    call enqueue
    mov eax, 20
    call enqueue
    mov eax, 30
    call enqueue
    call show               ; head 0 tail 3 count 3
    call halt

show:                       ; prints the three indices
    mov si, m_head
    call puts
    mov eax, [q.head]
    call print_dec
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

q:                          ; a circular queue: 8 slots, fixed capacity
.buf:   times 8 dd 0        ; the ring: 32 bytes
.head:  dd 0                ; index of the front: next to dequeue
.tail:  dd 0                ; the next free slot: next to enqueue
.count: dd 0                ; elements inside: 0 empty, 8 full
CAP equ 8                   ; a power of two: the wrap is one AND
; head and tail chase each other around the ring; nothing ever moves

m_head:  db "head ", 0
m_tail:  db " tail ", 0
m_count: db " count ", 0

tinyx86_lib
tinyqueue_lib
times 510-($-$$) db 0
dw 0xaa55
