; My First Bare Metal x86 Program - slide 8: the whole program, thirteen lines
; make run-08_program boots it; the screen shows TomJNET Community after the BIOS banner.
; Three classic mistakes, each one a line to change:
;   - delete "org 0x7c00": message becomes 0x0010, SI points into the interrupt table, garbage on screen
;   - delete the ", 0" after the text: the loop prints whatever follows in memory until it meets a zero
;   - delete "dw 0xaa55": the BIOS says "No bootable device"

bits 16
org 0x7c00
        mov si, message         ; SI -> first byte of the text
print:  lodsb                   ; AL = [SI], SI = SI + 1
        cmp al, 0               ; the terminator?
        je done
        mov ah, 0x0e            ; BIOS teletype: print AL
        int 0x10
        jmp print
done:   jmp $                   ; stay here forever
message: db "TomJNET Community", 0
times 510-($-$$) db 0
dw 0xaa55
