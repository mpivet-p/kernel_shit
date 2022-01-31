print_hex:
    push    ax
    push    cx
    push    dx

    ;Print 0x
    push    si
    mov	    si, hex_prefix
    call    print_string
    pop	    si

    call print_hex_loop

    ;Print newline
    mov	    si, newline
    call    print_string

    done:
	pop	dx
	pop	cx
	pop	ax
	ret

print_hex_loop:
    cmp	    si, 0x10
    jb	    phl_end

    ;Div : ax / cx = ax + dx
    mov	    ax, si
    mov	    dx, si
    and	    dx, 0x0F
    shr	    ax, 0x04
    mov	    si, ax
    push    dx
    call print_hex_loop
    pop	    si

    phl_end:
	mov	ax, si
    	call    print_hex_char
    	ret


print_hex_char:
    cmp	    ax, 9
    jg	    char
    add	    ax, 48
    jmp	    end
    char:
	add	ax, 55
    end:
        mov	ah, 0x0E
        int	0x10
        ret

