; Build an x86 Assembly Lab in 10 Minutes - slide 3: nasm and intel syntax
; Boot sector: make run-03_intel_syntax, or make check to compare the screen with 03_intel_syntax.expected.
; The slide's lines run unchanged; the lab helpers (lib/tinyx86.inc, episode 4) print the registers.
bits 16
org 0x7c00
%include "tinyx86.inc"

start:
    tinyx86_init

; Intel syntax: destination first, exactly as in Intel's manuals
mov ebx, 42             ; EBX = 42
mov eax, ebx            ; EAX = EBX  (a copy: EBX keeps 42)
add eax, 10             ; EAX = EAX + 10 = 52
mov [total], eax        ; memory at total = 52  (brackets mean memory)
mov ecx, total          ; ECX = the address of total, not the value
; the same copy in AT&T syntax (GNU as):  movl %ebx, %eax
; assemble: nasm -f bin main.asm -o main.bin   (bin = raw bytes)

    mov si, msg_ebx         ; ebx: 42     (unchanged by the copy)
    call puts
    mov eax, ebx
    call print_dec
    call newline
    mov si, msg_eax         ; eax: 52
    call puts
    mov eax, [total]
    call print_dec
    call newline
    mov si, msg_ecx         ; ecx: 0x00007cXX  (an address inside our sector)
    call puts
    mov eax, ecx
    call print_hex
    call newline
    call halt

total: dd 0             ; four bytes of data with a name
msg_ebx: db "ebx: ", 0
msg_eax: db "eax and [total]: ", 0
msg_ecx: db "ecx, the address of total: ", 0

tinyx86_lib
times 510-($-$$) db 0
dw 0xaa55
