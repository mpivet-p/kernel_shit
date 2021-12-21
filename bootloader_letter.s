[BITS 16]
[ORG 0x7C00]

call print_A
jmp $

print_A:
mov al, 65
mov ah, 0x0E
mov bl, 0x07
mov bh, 0x00
int 0x10
ret

times 510 - ($ - $$) db 0
dw 0xAA55
