clear_bios_screen:
    pusha
    mov	    ax, 0x03  ; text mode 80x25 16 colours
    int	    0x10
    popa
    ret
