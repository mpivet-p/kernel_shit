/** pic_acknowledge:
 *  Acknowledges an interrupt from either PIC 1 or PIC 2.
 *
 *  @param num The number of the interrupt
 */
void pic_acknowledge(unsigned integer interrupt)
{
	if (interrupt < PIC1_START_INTERRUPT || interrupt > PIC2_END_INTERRUPT) {
		return;
	}

	if (interrupt < PIC2_START_INTERRUPT) {
		outb(PIC1_PORT_A, PIC_ACK);
	} else {
		outb(PIC2_PORT_A, PIC_ACK);
	}
}
