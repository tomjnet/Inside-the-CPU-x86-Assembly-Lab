; My First Bare Metal x86 Program - slide 7: the loop, lodsb, cmp, je, jmp
; The slide's loop, with one extra print per trip: a dot after every character, so the screen shows
; one trip of the loop per letter: T.o.m.J.N.E.T. .C.o.m.m.u.n.i.t.y.

bits 16
org 0x7c00

        mov si, message     ; SI -> first byte of the text
print:  lodsb               ; AL = [SI], then SI = SI + 1
        cmp al, 0           ; is AL the terminator?
        je done             ; yes: jump if equal (the flags cmp set)
        mov ah, 0x0e
        int 0x10            ; print AL
        mov al, '.'         ; extra: one dot per trip around the loop
        int 0x10
        jmp print           ; back to lodsb for the next byte
done:   jmp $               ; the end: stay here forever

message: db "TomJNET Community", 0

times 510-($-$$) db 0
dw 0xaa55
