; tinyqueue.inc - TomJNET TinyX86 lab: the circular queue of episode 8.
;
; A ring of CAP dwords (CAP is a power of two, 8 by default) with a head index (the front, next to
; dequeue), a tail index (the next free slot, next to enqueue) and a count. Nothing ever moves:
; enqueue, dequeue and front are O(1). Include it after tinyx86.inc and expand it with
; `tinyqueue_lib` after your code, next to `tinyx86_lib`.
;
; Routines:
;   enqueue     eax = value; ZF = 1 (and nothing stored) when the queue is full     clobbers ecx
;   dequeue     eax = the oldest element, removed; ZF = 1 when it was empty        clobbers ecx
;   front       eax = the oldest element, kept                                      clobbers ecx
;   is_empty    ZF = 1 when empty
;   is_full     ZF = 1 when full
;
; A sample that shows one routine on its slide keeps its own copy and skips the library's with
; %define TINYQUEUE_NO_OBJECT (q and CAP), TINYQUEUE_NO_ENQUEUE, TINYQUEUE_NO_DEQUEUE (dequeue and
; front) or TINYQUEUE_NO_CHECKS (is_empty and is_full) before the include.

%macro tinyqueue_lib 0

%ifndef TINYQUEUE_NO_OBJECT
q:                          ; a circular queue: CAP slots, fixed capacity
.buf:   times 8 dd 0        ; the ring
.head:  dd 0                ; index of the front: next to dequeue
.tail:  dd 0                ; the next free slot: next to enqueue
.count: dd 0                ; elements inside: 0 empty, CAP full
CAP equ 8                   ; a power of two: the wrap is one AND
%endif

%ifndef TINYQUEUE_NO_ENQUEUE
enqueue:                    ; EAX = value
    cmp dword [q.count], CAP
    je .full
    mov ecx, [q.tail]
    mov [q.buf + ecx*4], eax
    inc ecx
    and ecx, CAP - 1
    mov [q.tail], ecx
    inc dword [q.count]
    cmp ecx, -1             ; ZF = 0: stored
.full:
    ret
%endif

%ifndef TINYQUEUE_NO_DEQUEUE
front:                      ; EAX = the oldest element, still in the queue
    mov ecx, [q.head]
    mov eax, [q.buf + ecx*4]
    ret
dequeue:                    ; EAX = the oldest element, removed
    cmp dword [q.count], 0
    je .empty
    call front
    inc dword [q.head]
    and dword [q.head], CAP - 1
    dec dword [q.count]
    cmp ecx, -1             ; ZF = 0: removed
.empty:
    ret
%endif

%ifndef TINYQUEUE_NO_CHECKS
is_empty:
    cmp dword [q.count], 0
    ret
is_full:
    cmp dword [q.count], CAP
    ret
%endif

%endmacro
