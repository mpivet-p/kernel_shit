%define ENDL 0x0D, 0x0A

print_hex:
    push    ax
    push    cx
    push    dx

    ;Print 0x
    mov	    dx, si
    mov	    si, hex_prefix
    call    print_string
    mov	    si, dx

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
    cmp	    si, 16
    jl	    phl_end

    ;Div : ax / cx = ax + dx
    mov	    dx, 0
    mov	    ax, si
    mov	    cx, 16
    div	    cx
    push    dx
    mov	    si, ax
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

