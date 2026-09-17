; Inside the CPU: What We Built - slide 5: the whole lab in one boot sector
; Every helper of the series in one sector: the screen routines (episodes 3 and 4), the vector on the bump
; allocator (episode 7) and the circular queue (episode 8). The screen shows the banner and 42.
bits 16
org 0x7c00
%include "tinyx86.inc"
%define TINYVEC_NO_GET      ; only what this sector calls: the rest would not fit in 510 bytes
%define TINYVEC_NO_SET
%define TINYVEC_NO_POP
%include "tinyvec.inc"
%define TINYQUEUE_NO_CHECKS
%include "tinyqueue.inc"

start:
; the whole lab in one boot sector: episodes 3 to 8
    tinyx86_init            ; segments and the stack             (4)
    mov si, banner          ; puts: int 0x10 in a loop           (3)
    call puts
    call vec_init           ; a vector on our four line heap     (7)
    mov eax, 42
    call vec_push           ; O(1), grows by doubling
    call enqueue            ; the ring: head, tail, count        (8)
    call dequeue            ; O(1), nothing moved
    call print_dec          ; 42, through the registers          (4, 5)
    call halt

banner: db "TinyX86 vector + queue: ", 0

tinyx86_lib
tinyvec_lib
tinyqueue_lib
times 510-($-$$) db 0
dw 0xaa55
