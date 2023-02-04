// What kind of code is here?
	.syntax unified
	.cpu cortex-m4
	.fpu fpv4-sp-d16

	.thumb // Oddly, this allows NON-thumb instructions (ie: standard ARM)

	.include "regs_stm32l4_inc.s"

	// The actual program
	.include "blink_inc.s"

