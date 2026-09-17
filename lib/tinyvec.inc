; tinyvec.inc - TomJNET TinyX86 lab: the dynamic array of episode 7 (a C++ vector in Assembly).
;
; The object is three dwords (vec.data, vec.size, vec.cap), the elements live in a buffer taken
; from a bump allocator that starts at 0x8000, right after the boot sector. Include it after
; tinyx86.inc and expand it with `tinyvec_lib` after your code, next to `tinyx86_lib`:
;
;   %include "tinyx86.inc"
;   %include "tinyvec.inc"
;   ...
;   tinyx86_lib
;   tinyvec_lib
;
; Routines (arguments and results in registers, as in episode 5):
;   vec_init            capacity 2, size 0                          clobbers eax, edx
;   alloc               eax = bytes  ->  eax = address              clobbers edx
;   vec_push            eax = value; grows when full                 clobbers ebx, ecx (and si, di, cx, edx on a grow)
;   vec_grow            capacity * 2, elements copied                clobbers eax, si, di, cx, edx
;   vec_get             ecx = index  ->  eax = element               clobbers ebx
;   vec_set             ecx = index, eax = value                     clobbers ebx
;   vec_pop             size - 1
;
; A sample that shows one routine on its slide keeps its own copy and skips the library's with
; %define TINYVEC_NO_ALLOC, TINYVEC_NO_PUSH, TINYVEC_NO_GROW, TINYVEC_NO_GET, TINYVEC_NO_SET or
; TINYVEC_NO_POP before the include.

%macro tinyvec_lib 0

vec:                        ; the object: 12 bytes
.data:  dd 0                ; address of the first element
.size:  dd 0                ; elements in use
.cap:   dd 0                ; slots allocated
heap_top: dd 0x8000         ; free memory starts after our sector

vec_init:                   ; an empty vector with room for 2
    mov eax, 8
    call alloc
    mov [vec.data], eax
    mov dword [vec.size], 0
    mov dword [vec.cap], 2
    ret

%ifndef TINYVEC_NO_ALLOC
alloc:                      ; EAX = bytes wanted  ->  EAX = address
    mov edx, [heap_top]
    add [heap_top], eax
    mov eax, edx
    ret
%endif

%ifndef TINYVEC_NO_PUSH
vec_push:                   ; EAX = value
    mov ecx, [vec.size]
    cmp ecx, [vec.cap]
    je .grow
    mov ebx, [vec.data]
    mov [ebx + ecx*4], eax
    inc dword [vec.size]
    ret
.grow:
    push eax
    call vec_grow
    pop eax
    jmp vec_push
%endif

%ifndef TINYVEC_NO_GROW
vec_grow:                   ; capacity doubles, the elements move
    mov eax, [vec.cap]
    add eax, eax
    mov [vec.cap], eax
    shl eax, 2
    call alloc
    mov si, [vec.data]
    mov di, ax
    mov cx, [vec.size]
    rep movsd
    mov [vec.data], eax
    ret
%endif

%ifndef TINYVEC_NO_GET
vec_get:                    ; ECX = index  ->  EAX = element
    mov ebx, [vec.data]
    mov eax, [ebx + ecx*4]
    ret
%endif

%ifndef TINYVEC_NO_SET
vec_set:                    ; ECX = index, EAX = value
    mov ebx, [vec.data]
    mov [ebx + ecx*4], eax
    ret
%endif

%ifndef TINYVEC_NO_POP
vec_pop:                    ; removes the last element
    dec dword [vec.size]
    ret
%endif

%endmacro
