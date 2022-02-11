[bits 32]
init_pm:

    mov	    ax, DATA_SEG
    mov	    ds, ax
    mov	    ss, ax
    mov	    es, ax
    mov	    fs, ax
    mov	    gs, ax

    mov	    ebp, 0x90000
    mov	    esp, ebp

    call    BEGIN_PM
