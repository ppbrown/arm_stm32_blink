// What kind of code is here?
	.syntax unified
	.cpu cortex-m4
	.fpu fpv4-sp-d16

	.thumb // Oddly, this allows NON-thumb instructions (ie: standard ARM)

	.include "regs_stm32f4_inc.s"


	.equ	DELAY_INTERVAL,	0x186004



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

	// Set the mode on the GPIOA, pin 5, to mode=output
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
	
	
	// Set the mode on the GPIOC, pin 13, to mode=input
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
	
	
	// since we know all pins disabled except
	// the one we care about, just easymode toggle
asm_led_toggle:
	ldr	r3, =GPIOA_ODR  // has port addr
	ldr     r1, [r3]	// has port addr contents

	mvns    r1, r1		// has ~(port)

	str	r1, [r3]

	bx      lr


delay:	
	ldr	r0, =DELAY_INTERVAL
loop2:
	nop
	sub	r0, #1
	cmp	r0, #0
	bge	loop2
	bx	lr

// This works	
blinkonly:	
	bl	delay
	bl	asm_led_toggle

	b	blinkonly
	

// This does not work
buttoncheck:	
	ldr	r0, =GPIOC_IDR
	ldr	r1, [r0]
	and	r1, #GPIO_PIN13
	cmp	r1, #0
	bne	buttoncheck

	bl	asm_led_toggle

button2:	
	ldr	r0, =GPIOC_IDR
	ldr	r1, [r0]
	and	r1, #GPIO_PIN13
	cmp	r1, #0
	beq	button2

	bl	asm_led_toggle

	b	buttoncheck
	

main:
	bl	asm_rcc_enable
	bl	asm_gpio_set_A5_output
	bl	asm_gpio_set_C13_input

	// Works fine if I call blinkonly. But buttoncheck does not
	//b	blinkonly
	b	buttoncheck
	

	/* This is called on first start, and if reset button pushed */
	/* In theory, would clear out stack,etc. */
reset_handler:
	
	b	main

	
