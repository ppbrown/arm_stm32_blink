	
	/********************************************************************\
	 *
	 * This file is meant to be included in other ASM files 
	 * This file should ONLY contain .equ definitions for cpu registers,
	 * and any other cpu-specific .EQU defs.
	 * The definitions in this file are targetted towards the CPU in an
	 * STI Nucleo-F401RE ARM cpu (Cortex M4 series)
	 *
	\********************************************************************/

	//    https://www.st.com/resource/en/reference_manual/rm0368-stm32f401xbc-and-stm32f401xde-advanced-armbased-32bit-mcus-stmicroelectronics.pdf


	/* Future note: according to the board docs,
	 * "the user button is connected to the I/O PC13 (pin 2)  ..."
	 * aka GPIOC13, 
	 */

	
// ******* Register definitions *******

	.equ	PERIPH_BASE, 0x40000000U
	.equ	PERIPH_BASE_AHB1, PERIPH_BASE + 0x20000
	.equ	PERIPH_BASE_AHB2, 0x50000000U
	
	.equ	RCC_BASE, PERIPH_BASE_AHB1 + 0x3800

	//Clock control for AHB1 peripherals (includes GPIO)
	.equ    AHB1ENR_OFFSET, 0x30
	.equ    AHB2ENR_OFFSET, 0x34
	.equ	RCC_AHB1ENR,	(RCC_BASE + AHB1ENR_OFFSET)
	.equ	RCC_AHB2ENR,	(RCC_BASE + AHB2ENR_OFFSET)


	// #define _REG_BIT(base, bit)		(((base) << 5) + (bit))
	// RCC_GPIOA       = _REG_BIT(0x30, 0),

	.equ	RCC_GPIOA_EN, (1 <<0)
	.equ	RCC_GPIOB_EN, (1 <<1)
	.equ	RCC_GPIOC_EN, (1 <<2)

	

	/*************************************************************************/
	/*   ......   GPIO Section .......                                       */
	/*************************************************************************/
	
	.equ	GPIO_BASE, PERIPH_BASE_AHB1

	.equ	GPIOA_BASE, GPIO_BASE + 0x000	// GPIO port A
	.equ	GPIOB_BASE, GPIO_BASE + 0x400	// GPIO port B
	.equ	GPIOC_BASE, GPIO_BASE + 0x800	// GPIO port C
	.equ	GPIOD_BASE, GPIO_BASE + 0xC00	// GPIO port D
	.equ	GPIOE_BASE, GPIO_BASE + 0x1000	// GPIO port E
	// F4 has no GPIOF or G
	.equ	GPIOH_BASE, GPIO_BASE + 0x1C00	// GPIO port H



	// These have to be shifted over to the appropriate slots in the
	// approprate GPIOx MODE register
	// GPIOA pin0, is bits 0 and1
	// GPIOA pin1, is bits 2 and 3, etc.

	.equ	GPIO_MODE_INPUT,  0x0
	.equ	GPIO_MODE_OUTPUT, 0x1
	.equ	GPIO_MODE_ALTF,   0x2
	.equ	GPIO_MODE_ANALOG, 0x3


	// Like the MODER register, these have to be left-shifted to match
	// which pin we are talking about
	.equ	GPIO_PUPD_NONE,     0x0
	.equ	GPIO_PUPD_PULLUP,   0x1
	.equ	GPIO_PUPD_PULLDOWN, 0x2

	
//GPIO-A control registers
	.equ	GPIOA_MODER,	GPIOA_BASE + 0x00	// GPIOA "mode register"
	.equ	GPIOA_OTYPER,	GPIOA_BASE + 0x04 	//Set GPIO pin type as push-pull or open drain
	.equ	GPIOA_OSPEEDR,	GPIOA_BASE + 0x08	//Set GPIO pin switching speed
	.equ	GPIOA_PUPDR,	GPIOA_BASE + 0x0C	//Set GPIO pin pull-up/pull-down
	.equ	GPIOA_IDR,	GPIOA_BASE + 0x10	//GPIO pin input data
	.equ	GPIOA_ODR,	GPIOA_BASE + 0x14	//GPIO pin output data
	.equ	GPIOA_BSRR,	GPIOA_BASE + 0x18	// Bit Set/Reset


//GPIO-B control registers
	.equ	GPIOB_MODER,	GPIOB_BASE + 0x00	//set GPIO pin mode as Input/Output/Analog
	// ...
//GPIO-C control registers
	.equ	GPIOC_MODER,	GPIOC_BASE + 0x00	//set GPIO pin mode as Input/Output/Analog
	.equ	GPIOC_OTYPER,	GPIOC_BASE + 0x04 	//Set GPIO pin type as push-pull or open drain
	.equ	GPIOC_OSPEEDR,	GPIOC_BASE + 0x08	//Set GPIO pin switching speed
	.equ	GPIOC_PUPDR,	GPIOC_BASE + 0x0C	//Set GPIO pin pull-up/pull-down
	.equ	GPIOC_IDR,	GPIOC_BASE + 0x10	//Set GPIO pin pull-up/pull-down
	.equ	GPIOC_ODR,	GPIOC_BASE + 0x14	//GPIO pin output data
	.equ	GPIOC_BSRR,	GPIOC_BASE + 0x18	// Bit Set/Reset

	
//GPIO-D control registers
	.equ	GPIOD_MODER,	GPIOD + 0x00	//set GPIO pin mode as Input/Output/Analog
	// ...


	// Masks to use with IDR or ODR registers

	.equ	GPIO_PIN0, 	1
	.equ	GPIO_PIN1, 	(1<<1)
	.equ	GPIO_PIN2, 	(1<<2)
	.equ	GPIO_PIN3, 	(1<<3)
	.equ	GPIO_PIN4, 	(1<<4)
	.equ	GPIO_PIN5, 	(1<<5)
	.equ	GPIO_PIN6, 	(1<<6)
	.equ	GPIO_PIN7, 	(1<<7)
	.equ	GPIO_PIN8, 	(1<<8)
	.equ	GPIO_PIN9, 	(1<<9)
	.equ	GPIO_PIN10, 	(1<<10)
	.equ	GPIO_PIN11, 	(1<<11)
	.equ	GPIO_PIN12, 	(1<<12)
	.equ	GPIO_PIN13, 	(1<<13)
	.equ	GPIO_PIN14, 	(1<<14)
	.equ	GPIO_PIN15, 	(1<<15)

