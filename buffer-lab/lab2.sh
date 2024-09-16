#!/bin/bash

# Compile and prepare
gcc -m32 -fno-stack-protector -z execstack -o vuln vuln.c
nasm -f elf32 file_del.asm
ld -m elf_i386 -o file_del file_del.o

# Generate payload
python3 ./lab2/exploit.py

# Run GDB with commands
gdb -q ./vuln << EOF
set disassembly-flavor intel
disassemble main
break *main+17
break *main+51
break *main+78
run \$(cat payload.bin)

# At first breakpoint (before strcpy)
info registers
x/32xw \$esp
continue

# At second breakpoint (after strcpy)
info registers
x/32xw \$esp
x/s \$esp
continue

# At third breakpoint (at ret instruction)
info registers
x/32xw \$esp
x/s \$esp
x/16i \$eip
backtrace
info frame
continue
EOF