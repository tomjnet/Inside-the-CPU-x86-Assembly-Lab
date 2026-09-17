; Build a C Style Array in Assembly - slide 11: the sum of an array, the loop the CPU loves
; One add per element, addresses rising by 4: the sum of 10 to 50 is 150. make check.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

; sum of the array: one read per element, all of them neighbours   O(n)
    xor eax, eax                ; sum = 0
    mov ecx, 0
add_up:
    add eax, [numbers + ecx*4]  ; sum += numbers[i]
    inc ecx
    cmp ecx, count
    jl add_up                   ; EAX = 150
; a cache line holds 16 ints: the CPU fetches 16 neighbours in one go
    mov si, m_sum
    call puts
    call print_dec
    call halt

numbers: dd 10, 20, 30, 40, 50
count equ ($ - numbers) / 4
m_sum: db "sum: ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
