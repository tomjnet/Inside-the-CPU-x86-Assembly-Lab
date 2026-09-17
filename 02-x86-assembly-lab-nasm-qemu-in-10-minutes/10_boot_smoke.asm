; Build an x86 Assembly Lab in 10 Minutes - slide 10: boot the empty sector
; The smallest boot sector: make run-10_boot_smoke shows the BIOS banner, "Booting from Hard Disk..."
; and then nothing. No "No bootable device" error means the BIOS accepted the sector and the CPU ran it.
; make check compares the screen with 10_boot_smoke.expected.

bits 16                 ; the CPU wakes up in 16 bit real mode
org 0x7c00              ; BIOS loads our 512 bytes at this address
start:
    cli                 ; no interrupts
    hlt                 ; stop: no "No bootable device" means we booted
    jmp start

times 510-($-$$) db 0   ; pad to 510 bytes
dw 0xaa55               ; the signature BIOS looks for: "bootable"
