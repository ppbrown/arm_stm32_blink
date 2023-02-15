	.syntax unified
	.cpu cortex-m4
	.fpu fpv4-sp-d16
	.thumb // Oddly, this allows NON-thumb instructions (ie: standard ARM)

	.include "regs_inc.S"


	/* This program waits for a "User Button" press,
	 * and the lights up the LED, on an STM32 Nucleo series board
	 * Currently only f401RE and L476VG have been tested/supported
	 */ 
	
	.equ	DELAY_INTERVAL,	0x186004


	.global main


	// enable clock for GPIOA and GPIOC
asm_rcc_enable:	
	ldr	r1, =RCC_GPIO_ENABLER
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

	ldr	r0, =GPIOC_PUPDR
	mov 	r1, #GPIO_PUPD_PULLUP
	lsl	r1, #(13*2)	// "pin13, x2 bits"
	str	r1, [r0]

	bx	lr
	
	
asm_led_toggle:
	ldr	r3, =GPIOA_ODR  // has port addr
	ldr     r1, [r3]	// has port addr contents

	mov.w	r2, #GPIO_PIN5
	eor	r1,r2

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

blinkonly:	
	bl	delay
	bl	asm_led_toggle

	b	blinkonly
	

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

	//b	blinkonly
	b	buttoncheck
	

	
