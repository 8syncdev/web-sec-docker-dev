; delete dummyfile in nasm

section .text
global _start
_start:
    jmp short ender
starter:
    xor eax, eax
    add al, 8
    add al, 2
    mov ebx, _filename
    int 0x80
_exit:
    xor eax, eax
    add al, 1
    int 0x80

ender:
    call starter
_filename db 'dummyfile'