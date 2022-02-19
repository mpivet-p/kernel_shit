ENTRY(kmain)

INPUT
(
    build/kernel.o
    build/interrupts.o
    build/io.o
    build/keyboard.o
    build/pic_ack.o
    build/load_idt.o
    build/interrupt_handler.o
)

SECTIONS
{
    . = 0x8000;

    .text : ALIGN(0x1000)
    {
        *(.text)
    }

    .data : ALIGN(0x1000)
    {
        *(.data)
    }

    .rodata : ALIGN(0x1000)
    {
        *(.rodata*)
    }

    .bss : ALIGN(0x1000)
    {
        *(COMMON)
        *(.bss)
    }

}
