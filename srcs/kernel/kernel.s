org 0x7C00
bits 16


start:
    jmp	    main

main:
    mov	    ax, 0x3
    int	    0x10
    cli
    hlt
