; tinyx86.inc - TomJNET TinyX86 lab: screen helpers for 16 bit real mode boot sectors.
;
;   bits 16
;   org 0x7c00
;   %include "tinyx86.inc"     ; the two macros below, no code yet
;   start:
;       tinyx86_init           ; segments and stack (episode 4 explains the stack)
;       ...                    ; your program: call puts, print_dec, print_hex, newline, halt
;   tinyx86_lib                ; expands the routines here, after your code and data
;   times 510-($-$$) db 0
;   dw 0xaa55
;
; Every routine keeps every register except the ones it names. All of them use only the
; BIOS teletype service (int 0x10, AH = 0x0e), so they work on QEMU and on a real PC.

%macro tinyx86_init 0           ; DS = ES = SS = 0, stack just under the boot sector, flags sane
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti
    cld
%endmacro

%macro tinyx86_lib 0

putc:                           ; AL = one character
    push ax
    push bx
    mov ah, 0x0e
    mov bx, 0x0007
    int 0x10
    pop bx
    pop ax
    ret

puts:                           ; SI = address of a zero terminated string
    push ax
    push si
.next:
    lodsb
    test al, al
    jz .done
    call putc
    jmp .next
.done:
    pop si
    pop ax
    ret

newline:                        ; carriage return plus line feed
    push ax
    mov al, 13
    call putc
    mov al, 10
    call putc
    pop ax
    ret

print_dec:                      ; EAX = unsigned 32 bit value, printed in decimal
    pushad
    mov ecx, 10
    xor ebx, ebx                ; digits pushed so far
.divide:
    xor edx, edx
    div ecx                     ; EAX = EAX / 10, EDX = EAX mod 10
    push dx
    inc ebx
    test eax, eax
    jnz .divide
.emit:
    pop ax
    add al, '0'
    call putc
    dec ebx
    jnz .emit
    popad
    ret

print_hex:                      ; EAX printed as 0x and 8 hex digits
    pushad
    mov ebx, eax
    mov al, '0'
    call putc
    mov al, 'x'
    call putc
    mov cx, 8
.digit:
    rol ebx, 4
    mov al, bl
    and al, 0x0f
    add al, '0'
    cmp al, '9'
    jbe .out
    add al, 'a' - '9' - 1
.out:
    call putc
    loop .digit
    popad
    ret

halt:                           ; the end: stop the CPU for good
    cli
    hlt
    jmp halt

%endmacro
