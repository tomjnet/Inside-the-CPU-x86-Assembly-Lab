; My First Bare Metal x86 Program - slide 4: the skeleton, where the bytes live
; The empty boot sector: make run-04_skeleton shows the BIOS banner, "Booting from Hard Disk..." and
; then nothing, which is success (no "No bootable device"). make check compares the screen.

bits 16                 ; 16 bit real mode: what the CPU is in at boot
org 0x7c00              ; the BIOS puts us here: addresses count from it
start:
    jmp $               ; the program: stay here (we fill this in next)
times 510-($-$$) db 0   ; zeros up to byte 510
dw 0xaa55               ; bytes 511 and 512: the boot signature
