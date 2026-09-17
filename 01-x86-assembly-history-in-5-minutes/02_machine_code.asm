; Assembly Language in 5 Minutes - slide 2: before assembly, programming in numbers
; Not a boot sector: assemble it and look at the bytes.
;   nasm -f bin 02_machine_code.asm -o build/02_machine_code.bin
;   ndisasm -b 16 build/02_machine_code.bin      (or: make dump-02_machine_code)
; Expected: 00000000  B80A00            mov ax,0xa

; what the CPU reads: three bytes, one instruction
;   10111000  00001010  00000000
;      B8        0A        00
; the same three bytes, written for a human:
bits 16
mov ax, 10          ; B8 0A 00: load 10 into the register AX
