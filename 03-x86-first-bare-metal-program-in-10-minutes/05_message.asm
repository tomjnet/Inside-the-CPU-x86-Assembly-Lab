; My First Bare Metal x86 Program - slide 5: the message, bytes in memory with a name
; Prints the message, then a second line that says how many bytes db wrote. The printing loop is the
; one from slide 7; call and ret (episode 5) just let us reuse it for both strings.

bits 16
org 0x7c00

start:
    mov si, message         ; SI = 0x7c10: SI points at the 'T'
    call print
    mov si, size_note
    call print
done:   jmp $

print:  lodsb                   ; AL = [SI], SI = SI + 1
        cmp al, 0
        je .end
        mov ah, 0x0e
        int 0x10
        jmp print
.end:   ret

message: db "TomJNET Community", 0
; db = define bytes: 17 letters, then one zero byte: 18 bytes in memory
; the zero is how the loop will know where the text ends
; the label is a name for the address of the first byte:
;   with org 0x7c00 the assembler computes message = 0x7c10
size_note: db 13, 10, "message is 18 bytes: 17 letters and a zero", 0

times 510-($-$$) db 0
dw 0xaa55
