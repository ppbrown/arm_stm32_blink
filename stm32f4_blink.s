// This file is ".S" instead of ".s" so we can use #define
	
	/* This code inspired by the blink demo at
	 *  https://github.com/jrsa/stm32f4_blink
	 * Much thanks to the author there.
	 * The main difference is that that code is C-based, and
	 * leans heavily on the "libopencm3" library at
	 *  https://github.com/libopencm3/libopencm3/
	 *
	 * In contrast, the goal of this code is to deliver a pure
	 * ASM based, stand-alone executable
	 *
	 * Going from zero, to something functional in ASM is an extreme sport.
	 * Instead, I developed this by swapping C-functions with ASM routines,
	 * one by one.
	 * - Philip Brown, 2023
	*/


	/* Additional porting notes:
	 * The original was extremely flexible, allowing for semi-easy changing
	 * of values.
	 * That was C code. This is assembly.
	 * IMO, the whole point of ASM is to write small, hard, and fast routines.
	 * Yes I could have spent 10x the amount of time writing "flexible"
	 * function-like entry points.. But honestly, I didnt want to work that hard!
	 *
	 * I believe the board I wrote this on, uses "GP IO Register A", 
	 * "Pin 5", for the led. Hence the use of "GPIOA", and "GPIO5".
	 * 
	 * If you need different hardware supported, you will have to do
	 * the research, update the definitions in the included "reg.s" file,
	 * and then adjust the references in here as needed.
	 *
	 */

/* Random note: you can name the file with ".S" instead of ".s" to use preprocessing */

// What kind of code is here?
	.syntax unified
	.cpu cortex-m4
	.fpu fpv4-sp-d16

	.thumb // Oddly, this allows NON-thumb instructions (ie: standard ARM)

	.include "stm32f4_inc.s"	// If you change this, also change CPU in Makefile

	.equ	DELAY_INTERVAL,	0x186004



	// Export functions so they can be called from other file
	.global asm_rcc_enable
	.global asm_gpio_set_mode_output
	.global asm_gpio_toggle
	.global reset_handler
	.global main


	// Only enable clock for GPIOA, not all possible ones
asm_rcc_enable:	
	ldr	r1, =RCC_REG_GPIOA
	ldr	r2, =RCC_BIT_GPIOA
	ldr	r3, [r1]
	orr	r3, r2
	str	r3, [r1]
	bx	lr

	// Set the mode on the pin we want, to mode=output
asm_gpio_set_mode_output:	
	ldr	r0,=GPIOA_MODER
	ldr	r1, [r0]	// has current gpioa value
	ldr.w	r2,=GPIO_MODE_MASK_PIN5
	mvns	r2, r2		// has ~GPIO_MODE_MASK_PIN5
	and.w	r1, r2
	ldr	r2,=GPIO_MODE_OUTPUT_PIN5
	orr	r1, r2
	str	r1, [r0]

	ldr	r0,=GPIOA_PUPDR
	ldr	r1, [r0]	// has current gpioa value
	ldr.w	r2,=GPIO_PUPD_MASK_PIN5
	mvns	r2, r2		// has ~GPIO_PUPD_MASK_PIN5
	and.w	r1, r2
	str	r1, [r0]

	bx	lr
	

////	ldr	r2,#GPIO_MODE_OUTPUT_PIN5

	
	
	// We specifically only toggle pin5 for GPIOA
asm_gpio_toggle:
	ldr	r3, =GPIOA_ODR  // has port addr
	ldr     r1, [r3]	// has port addr contents
	ldr     r2, [r3]	// has port same
	mvns    r2, r2		// has ~(port)
	
	and.w   r1, r1, #GPIO5		// port & GPIO5
	lsls    r1, r1, #16		// has (port & GPIO5) << 16

	and.w   r2, r2, #GPIO5		// has ~port & GPIO5

	orrs    r1, r2			// r1 has all the goodies

	ldr	r3, =GPIOA_BSRR
	str	r1, [r3]

	bx      lr


main:
	bl	asm_rcc_enable
	bl	asm_gpio_set_mode_output
loop1:
	ldr	r0, =DELAY_INTERVAL
loop2:
	nop
	sub	r0, #1
	cmp	r0, #0
	bge	loop2

	bl	asm_gpio_toggle

	b	loop1
	
	

	/* This is called on first start, and if reset button pushed */
	/* In theory, would clear out stack,etc. */
reset_handler:
	
	b	main

	
