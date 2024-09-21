#!/bin/bash

# Setup directory and file
# mkdir -p /tmp/dummy
# touch /tmp/dummy/dummyfile
# ls -R /tmp

# Create environment variable DUMMY for 'dummyfile' location
# export DUMMY=/tmp/dummy/dummyfile
# echo $DUMMY

# Disable Address space layout randomization
sudo sysctl -w kernel.randomize_va_space=0

# Compile 'vuln.c' to 'vuln' program
gcc vuln.c -o vuln.out -fno-stack-protector -z ex
ecstack -mpreferred-stack-boundary=2

# Generate payload
python3 ./lab3/exploit.py

# Run GDB with commands
gdb -q ./vuln << EOF
set disassembly-flavor intel
disassemble main
break *main+48
run \$(cat payload.bin)

# At breakpoint (after strcpy)
info registers
x/32xw \$esp
x/s \$esp
x/16i \$eip
backtrace
info frame

# Continue execution
continue
EOF

# Check if file was deleted
tree /tmp