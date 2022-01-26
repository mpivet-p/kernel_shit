org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp	    main

%include "srcs/bootloader/print_string.s"
%include "srcs/bootloader/print_hex.s"

main:
    call    clear_screen
    mov	    si, hello_world 
    call    print_string
    mov	    ah, 0
    int	    0x16		    ; wait for keypress

    cli
    hlt
    jmp	    $

clear_screen:
    pusha
    mov	    ax, 0x03  ; text mode 80x25 16 colours
    int	    0x10
    popa
    ret

hello_world:
db	"Hello World!", 0
nbr:
dw	42
hex_prefix:
db	"0x", 0
newline:
db	ENDL, 0

times	510 - ($ - $$) db 0
dw	0xAA55
