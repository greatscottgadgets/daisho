/* Linker script to configure memory regions. */
MEMORY
{
	FLASH		(rx)	: ORIGIN = 0x00000000, LENGTH = 0x8000
	RAM			(rwx)	: ORIGIN = 0x10000000, LENGTH = 0x1000
	RAM_USB		(rwx)	: ORIGIN = 0x20004000, LENGTH = 0x0800
}
