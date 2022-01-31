[org 0x7C00]
[bits 16]

%define ENDL 0x0D, 0x0A

start:
    mov	    [BOOT_DRIVE], dl
    jmp	    main

main:
    call    clear_screen
    ;mov	    si, hello_world 
    ;call    print_string
    ;mov	    ah, 0
    ;int	    0x16		    ; wait for keypress

    mov	    bp, 0x8000
    mov	    sp, bp
    mov	    bx, 0x9000
    mov	    dh, 2
    mov	    dl, [BOOT_DRIVE]
    call    disk_load

    cli
    hlt
    jmp	    $

clear_screen:
    pusha
    mov	    ax, 0x03  ; text mode 80x25 16 colours
    int	    0x10
    popa
    ret

%include "srcs/bootloader/print_string.s"
%include "srcs/bootloader/print_hex.s"
%include "srcs/bootloader/disk_load.s"

BOOT_DRIVE db	0

hello_world:
db	"Hello World!", 0
hex_prefix:
db	"0x", 0
newline:
db	ENDL, 0

times	510 - ($ - $$) db 0
dw	0xAA55

; To test the disk data
times 256 dw 0xdada
times 256 dw 0xface