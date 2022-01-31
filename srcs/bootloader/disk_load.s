disk_load:
    push    dx		; To save the number of sectors requested

    mov	    ah, 0x02	; BIOS read sector function
    mov	    al, dh	; Numbers of sectors to read
    mov	    ch, 0x00	; Cylinder 0
    mov	    dh, 0x00	; Head 0
    mov	    cl,	0x02	; Start reading from the second sector

    int	    0x13

    jc	    disk_error	; If carry flag -> exec error function

    pop	    dx
    cmp	    dh, al	; Check that the right amount of sectors has been read
    jne	    disk_error
    ret

disk_error:
    mov	    si, DISK_ERROR_MSG
    call    print_string
    jmp	    $

DISK_ERROR_MSG:
    db	    "Disk read error!", 0
