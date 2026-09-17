# Inside the CPU: x86 Assembly Lab - samples (one NASM source per .asm file, most of them boot sectors)
#
#   make                 assemble every sample into build/<name>.bin
#   make run-03_hello    boot one sample in QEMU (opens the QEMU window)
#   make dump-03_hello   disassemble one sample with ndisasm (the bytes the CPU sees)
#   make check           assemble and boot every sample with no window, compare the screen with <name>.expected
#   make clean           remove build/
#
# Tools: nasm, ndisasm, qemu-system-i386 (Ubuntu: sudo apt install nasm qemu-system-x86 make binutils gdb).
# The helpers of the lab live in ../lib/tinyx86.inc; nasm finds them through -I.

NASM      ?= nasm
QEMU      ?= qemu-system-i386
QEMUFLAGS ?= -cpu qemu32
LIB       := ../lib

SRCS := $(sort $(wildcard *.asm))
BINS := $(SRCS:%.asm=build/%.bin)

all: $(BINS)
	@echo assembled $(words $(BINS)) samples

build/%.bin: %.asm $(wildcard $(LIB)/*.inc) | build
	$(NASM) -f bin -I $(LIB)/ $< -o $@

build:
	mkdir -p build

run-%: build/%.bin
	$(QEMU) $(QEMUFLAGS) -drive format=raw,file=$<

dump-%: build/%.bin
	ndisasm -b 16 $<

check:
	bash ../check.sh .

clean:
	rm -rf build

.PHONY: all check clean
