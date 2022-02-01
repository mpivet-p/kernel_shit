; GDT
gdt_start:

gdt_null:		; Mandatory null descriptor
    dd	    0x00000000
    dd	    0x00000000

gdt_code:		; Code segment descriptor
    dw	    0xffff  	; Limits (bits 0 - 15)
    dw	    0x0000  	; Base (bits 0 - 15)
    db	    0x00    	; Base (bits 16 - 23)
    db	    10011010b	; Present (1) privilege (00) descriptor type (1) -> 1001b
			; - code (1) conforming (0) readable (1) accessed (0) -> 1010b
    db	    11001111b	; Granularity (1), 32 bits dflt (1), 64 bits seg (0), AVL (0) -> 1100b
			; - limit (bits 16 - 19)
    db	    0x00	; Base (bits 24 - 31)

gdt_data:		; Same as code segment except for the type flags
    dw	    0xffff  	; Limits (bits 0 - 15)
    dw	    0x0000  	; Base (bits 0 - 15)
    db	    0x00    	; Base (bits 16 - 23)
    db	    10010010b	; Type flags, code (0), expand down (0), writable (1), accessed (0) -> 0010b
    db	    11001111b	;
    db	    0x00	; Base (bits 24 - 31)

gdt_end:		; Allow to calculate gdt size

; GDT Descriptor
gdt_descriptor:
    dw	    gdt_end - gdt_start - 1	; Size of our GDT (always -1 of the true size)
    dd	    gdt_start			; start address of our gdt


CODE_SEG    eq	gdt_code - gdt_start
DATA_SEG    eq	gdt_data - gdt_start
