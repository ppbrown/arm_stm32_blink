/* Linker script for Nucleo F401RE  (STM32F411RE, 512K flash, 96K RAM). 
 *
 * lifted from libopencm3
 * 
 * This file defines the program entrypoint
 *   (the reset_handler, which cleans up before calling user entrypoint)
 *
 * This file defines cpu-specific defs for things like rom/ram start addr and size.
 * 
 * It defines certain bin/elf type magical defs like
 *   .text
 *   .data
 *   .bss
 *
 * It also defines the name of the vector_table pointer,
 *  (which is fleshed out in startup_stm32xxxx)
 *  and related named addresses such as:
 * 
 * _etext
 * _data
 * _ebss
 * end
 * _stack
 */

/* Define memory regions. */
MEMORY
{
	rom (rx) : ORIGIN = 0x08000000, LENGTH = 512K
	ram (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
}



/* Enforce that the program provide a vector table. */
EXTERN (vector_table)

/* Define the entry point of the final executable . */
ENTRY(reset_handler)

/* Define ELF sections. */
SECTIONS
{
	.text : {
		*(.vectors)	/* Vector table */
		*(.text*)	/* Program code */
		. = ALIGN(4);
		*(.rodata*)	/* Read-only data */
		. = ALIGN(4);
	} >rom


	. = ALIGN(4);
	_etext = .;

	/* ram, but not cleared on reset, eg boot/app comms */
	.noinit (NOLOAD) : {
		*(.noinit*)
	} >ram
	. = ALIGN(4);

	.data : {
		_data = .;
		*(.data*)	/* Read-write initialized data */
		*(.ramtext*)    /* "text" functions to run in ram */
		. = ALIGN(4);
		_edata = .;
	} >ram AT >rom
	_data_loadaddr = LOADADDR(.data);

	.bss : {
		_bss = .;
		*(.bss*)	/* Read-write zero initialized data */
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
	} >ram

	/*
	 * The .eh_frame section appears to be used for C++ exception handling.
	 * You may need to fix this if you're using C++.
	 */
	/DISCARD/ : { *(.eh_frame) }

	. = ALIGN(4);
	end = .;
}

/* this gets used by vector_table */
PROVIDE(_stack = ORIGIN(ram) + LENGTH(ram));

