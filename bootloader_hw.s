[BITS 16]
[ORG 0x7C00]

mov	si, hello_world 
call	putstr
jmp	$

putstr:
mov	al, [si]
call	putchar
inc	si
test	al, al
jnz	putstr
ret

putchar:
mov	ah, 0x0E
mov	bl, 0x07
mov	bh, 0x00
int	0x10
ret

hello_world db 'Hello World!', 0
times	510 - ($ - $$) db 0
dw	0xAA55
