[org 0x7C00]
[bits 16]

KERNEL_OFFSET	equ 0x1000

    mov	    [BOOT_DRIVE], dl
    mov	    bp, 0x9000
    mov	    sp, bp

    mov	    si, MSG_REAL_MODE
    call    print_string

    call    load_kernel

    call    switch_to_pm	; Never returning

    jmp	    $

%include "srcs/bootloader/switch_to_pm.s"
%include "srcs/bootloader/gdt.s"
%include "srcs/bootloader/print_string.s"
%include "srcs/bootloader/print_string_pm.s"
%include "srcs/bootloader/init_pm.s"
%include "srcs/bootloader/load_kernel.s"
%include "srcs/bootloader/disk_load.s"

[bits 32]

BEGIN_PM:
    mov	    ebx, MSG_PROT_MODE
    call    print_string_pm

    call    KERNEL_OFFSET

    jmp	    $

[bits 16]
; Global variables
BOOT_DRIVE	db  0
MSG_REAL_MODE	db  "Started in 16 - bit Real Mode" , 0
MSG_PROT_MODE	db  "Successfully landed in 32 - bit Protected Mode" , 0
MSG_LOAD_KERNEL	db  "Loading kernel into memory.." , 0

; Bootsector padding
times	510 - ($ - $$) db 0
dw	0xAA55
