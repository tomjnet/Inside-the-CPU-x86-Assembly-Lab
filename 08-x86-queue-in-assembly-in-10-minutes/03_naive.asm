; Build a Queue in Assembly - slide 3: the naive queue, dequeue shifts everything, O(n)
; A queue on the array of episode 6: one dequeue returns 10 and moves the other three elements left.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init
    mov si, m_before        ; before: 10 20 30 40  count 4
    call puts
    call show
    call naive_dequeue
    mov si, m_front         ; dequeue returned: 10
    call puts
    call print_dec
    call newline
    mov si, m_after         ; after:  20 30 40  count 3
    call puts
    call show
    call halt

naive_dequeue:              ; EAX = the front, then everything shifts
    mov eax, [buf]          ; the front element: buf[0]
    mov ecx, 0
.shift:
    mov edx, [buf + ecx*4 + 4]
    mov [buf + ecx*4], edx  ; buf[i] = buf[i+1]:  n - 1 moves
    inc ecx
    cmp ecx, [count]
    jl .shift               ; O(n) for every single dequeue
    dec dword [count]
    ret

show:                       ; prints the live elements and the count
    push eax
    xor ecx, ecx
.next:
    cmp ecx, [count]
    jge .done
    mov eax, [buf + ecx*4]
    call print_dec
    mov al, ' '
    call putc
    inc ecx
    jmp .next
.done:
    mov si, m_count
    call puts
    mov eax, [count]
    call print_dec
    call newline
    pop eax
    ret

buf:   dd 10, 20, 30, 40, 0
count: dd 4
m_before: db "before: ", 0
m_front:  db "dequeue returned: ", 0
m_after:  db "after:  ", 0
m_count:  db " count ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
