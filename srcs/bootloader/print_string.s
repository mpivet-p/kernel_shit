print_string:
    push    ax

    .loop:
        lodsb		    ; loads next char in al
        or	    al, al
        jz	    .done
    
        ;write
        mov ah, 0x0E
        int 0x10
    
        jmp	    .loop
    
    .done:
        pop	    ax
        ret
