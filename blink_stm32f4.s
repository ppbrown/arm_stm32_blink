// What kind of code is here?
	.syntax unified
	.cpu cortex-m4
	.fpu fpv4-sp-d16

	.thumb // Oddly, this allows NON-thumb instructions (ie: standard ARM)

	.include "regs_stm32f4_inc.s"


	.equ	DELAY_INTERVAL,	0x186004



	// Export functions so they can be called from other file
	.global asm_rcc_enable
	.global asm_gpio_set_mode_output
	.global asm_gpio_toggle
	.global reset_handler
	.global main


	// enable clock for GPIOA and GPIOC
asm_rcc_enable:	
	ldr	r1, =RCC_AHB1ENR
	mov	r2, #RCC_GPIOA_EN
	orr	r2, #RCC_GPIOC_EN
	
	ldr	r3, [r1]	// Load in values for all clocks
	orr	r3, r2		// just OR, since we KNOW we are adding bits only
	str	r3, [r1]
	bx	lr

	// Set the mode on the pins we want, to mode=output
	// be ugly and ignore prior settings.
	// If we were nice we would merge with values for other pins
asm_gpio_set_A5_output:
	ldr	r0, =GPIOA_MODER
	
	mov 	r1, #GPIO_MODE_OUTPUT
	lsl	r1, #(5*2)	// "pin5, x2 bits"
	str	r1, [r0]

	ldr	r0, =GPIOA_PUPDR
	mov 	r1, #GPIO_PUPD_PULLUP
	lsl	r1, #(5*2)	// "pin5, x2 bits"
	str	r1, [r0]

	bx	lr
	

		// Set the mode on the pins we want, to mode=output
	// be ugly and ignore prior settings.
	// If we were nice we would merge with values for other pins
asm_gpio_set_C13_input:
	ldr	r0, =GPIOC_MODER
	
	mov 	r1, #GPIO_MODE_INPUT
	lsl	r1, #(13*2)	// "pin13, x2 bits"
	str	r1, [r0]

	ldr	r0, =GPIOA_PUPDR
	mov 	r1, #GPIO_PUPD_PULLUP
	lsl	r1, #(13*2)	// "pin13, x2 bits"
	str	r1, [r0]

	bx	lr
	


	// Cheat. Just reverse ALL pins, since
	// we know all the things we dont care about
	// are disabled anyway!
asm_gpio_toggle:
	ldr	r3, =GPIOA_ODR  // has port addr
	ldr     r1, [r3]	// has port addr contents

	// new
	mvns    r1, r1		// has ~(port)

	
/*	
	ldr     r2, [r3]	// has port same
	mvns    r2, r2		// has ~(port)

	and.w   r1, r1, #GPIO5		// port & GPIO5
	lsls    r1, r1, #16		// has (port & GPIO5) << 16

	and.w   r2, r2, #GPIO5		// has ~port & GPIO5

	orrs    r1, r2			// r1 has all the goodies

	ldr	r3, =GPIOA_BSRR
	*/

	str	r1, [r3]
	

	bx      lr


main:
	bl	asm_rcc_enable
	bl	asm_gpio_set_A5_output
	bl	asm_gpio_set_C13_input


	// Start with it "on", hopefully.
	bl	asm_gpio_toggle

loop1:
	ldr	r0, =GPIOC_IDR
	ldr	r1, [r0]
	and	r1, #GPIO_PIN13
	cmp	r0, #0
	bne	loop1

	bl	asm_gpio_toggle

loop2:
	ldr	r0, =GPIOC_IDR
	ldr	r1, [r0]
	and	r1, #GPIO_PIN13
	cmp	r0, #0
	beq	loop2

	bl	asm_gpio_toggle

	b	loop1

	
	

	/* This is called on first start, and if reset button pushed */
	/* In theory, would clear out stack,etc. */
reset_handler:
	
	b	main

	
