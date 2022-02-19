#define VIDEO_ADDR	    0xb8000
#define VGA_WIDTH	    80
#define VGA_HEIGHT	    25
#define SET_COLOR(f, b, l)  (f << 4) | l << 3 | (b & 0x07)
#include <stdint.h>
#include "io.h"

void	clear_line(int y)
{
    volatile uint16_t *addr;
    int	    x;

    x = 0;
    addr = (volatile uint16_t*)VIDEO_ADDR + (y * VGA_HEIGHT * 2);
    while (x < VGA_WIDTH)
    {
	addr[x] = ' ' | (7 << 8);
	x++;
    }
}

void	clear_screen(void)
{
    int	    y;

    y = 0;
    while (y < VGA_HEIGHT)
    {
	clear_line(y);
	y++;
    }
}

void	write_char(unsigned char c, unsigned char col, int x, int y)
{
    volatile uint16_t *addr = (volatile uint16_t*)VIDEO_ADDR + (y * 80 + x);
    *addr = c | (col << 8);
}

void	enable_cursor(void)
{
    outb(0x3D4, 0x0A);
    outb(0x3D5, (inb(0x3D5) & 0xC0) | 0);
    
    outb(0x3D4, 0x0B);
    outb(0x3D5, (inb(0x3D5) & 0xE0) | 24);
}

void	set_cursor(uint8_t x, uint8_t y)
{
    uint16_t	pos;

    pos = y * VGA_WIDTH + x;

    outb(0x3D4, 0xF);
    outb(0x3D5, (uint8_t)(pos & 0xFF));
    outb(0x3D4, 0xE);
    outb(0x3D5, (uint8_t)((pos >> 8) & 0xFF));
}

void	kmain(void)
{
    clear_screen();
    enable_cursor();
    set_cursor(0, 0);
//    write_char('X', SET_COLOR(0, 4, 1), 79, 20);
}
