#include <stdint.h>
#include "io.h"
#include "pic.h"

/*  pic_acknowledge:
**  Acknowledges an interrupt from either PIC 1 or PIC 2.
**  @param num The number of the interrupt
*/

void    pic_acknowledge(uint32_t interrupt)
{
	if (interrupt < PIC_1_OFFSET || interrupt > PIC_2_END) {
		return;
	}

	if (interrupt < PIC_2_OFFSET) {
		outb(PIC_1, PIC_ACKNOWLEDGE);
	} else {
		outb(PIC_2, PIC_ACKNOWLEDGE);
	}
}
