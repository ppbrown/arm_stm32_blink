	
	/********************************************************************\
	 *
	 * This file is meant to be included in other ASM files 
	 * This file should ONLY contain .equ definitions for cpu registers,
	 * and any other cpu-specific .EQU defs.
	 * The definitions in this file are targetted towards the CPU in an
	 * STI Nucleo-F401RE ARM cpu (Cortex M4 series)
	 *
	\********************************************************************/

	/* Future note: according to the board docs,
	 * "the user button is connected to the I/O PC13 (pin 2)  ..."
	 * aka GPIOC13, 
	 */

	
// ******* Register definitions *******

	.equ	PERIPH_BASE, 0x40000000U
	.equ	PERIPH_BASE_AHB1, PERIPH_BASE + 0x20000
	.equ	PERIPH_BASE_AHB2, 0x48000000U
	
	.equ	RCC_BASE, PERIPH_BASE_AHB1 + 0x1000

	.equ	AHB2ENR_OFFSET, 0x4c
	//Clock control for AHB1 peripherals (includes GPIO)
	.equ	RCC_AHB2ENR,	(RCC_BASE + AHB2ENR_OFFSET)


	// #define _REG_BIT(base, bit)		(((base) << 5) + (bit))
	// RCC_GPIOA       = _REG_BIT(0x30, 0),

	.equ	RCC_GPIOA, AHB2ENR_OFFSET <<5

	// #define _RCC_REG(i)             MMIO32(RCC_BASE + ((i) >> 5))
	// #define _RCC_BIT(i)             (1 << ((i) & 0x1f))

	// rcc_periph_clock_enable(RCC_GPIOA);
        // _RCC_REG(RCC_GPIOA) |= _RCC_BIT(RCC_GPIOA);

	.equ	RCC_REG_GPIOA, RCC_GPIOA    // full reduces to RCC_BASE + AHB2ENR_OFFSET, which IS GPIOA
	.equ	RCC_BIT_GPIOA, 1 << ((RCC_GPIOA) & 0x1f)



	/*************************************************************************/
	/*   ......   GPIO Section .......                                       */
	/*************************************************************************/
	
	.equ	GPIO_BASE, PERIPH_BASE_AHB2

	.equ	GPIOA, GPIO_BASE + 0x000	// GPIO port A (also "GPIO_PORT_A_BASE")
	.equ	GPIOB, GPIO_BASE + 0x400	// GPIO port B (also "Base")
	.equ	GPIOC, GPIO_BASE + 0x800	// GPIO port C (also "Base")
	.equ	GPIOD, GPIO_BASE + 0xC00	// GPIO port D (also "Base")
	.equ	GPIOE, GPIO_BASE + 0x1000	// GPIO port E (also "Base")
	.equ	GPIOF, GPIO_BASE + 0x1400	// GPIO port F (also "Base")

	.equ	GPIO5,	(1 << 5)	// GPIO ports, pin5
	.equ	GPIO13,	(1 << 13)	// GPIO ports, pin13

	.equ	GPIO_MODE_INUT,	  0x0
	.equ	GPIO_MODE_OUTPUT, 0x1
	.equ	GPIO_MODE_AF,     0x2
	.equ	GPIO_MODE_ANALOG, 0x3
	
	.equ	GPIO_PUPD_NONE,     0x0
	.equ	GPIO_PUPD_PULLUP,   0x1
	.equ	GPIO_PUPD_PULLDOWN, 0x2

	
	.equ	GPIO_PUPD_MASK_PIN5, (0x3 << (2 * (5)))
	.equ	GPIO_MODE_MASK_PIN5, (0x3 << (2 * (5)))
	.equ	GPIO_MODE_OUTPUT_PIN5, (GPIO_MODE_OUTPUT) << (2 * (5))


//GPIO-A control registers
	.equ	GPIOA_MODER,	GPIOA + 0x00	//set GPIO pin mode as Input/Output/Analog
	.equ	GPIOA_OTYPER,	GPIOA + 0x04 	//Set GPIO pin type as push-pull or open drain
	.equ	GPIOA_OSPEEDR,	GPIOA + 0x08	//Set GPIO pin switching speed
	.equ	GPIOA_PUPDR,	GPIOA + 0x0C	//Set GPIO pin pull-up/pull-down
	.equ	GPIOA_ODR,	GPIOA + 0x14	//GPIO pin output data
	.equ	GPIOA_BSRR,	GPIOA + 0x18	// Bit Set/Reset


//GPIO-B control registers
	.equ	GPIOB_MODER,	GPIOB + 0x00	//set GPIO pin mode as Input/Output/Analog
	// ...
//GPIO-C control registers
	.equ	GPIOC_MODER,	GPIOC + 0x00	//set GPIO pin mode as Input/Output/Analog
	// ...
	
//GPIO-D control registers
	.equ	GPIOD_MODER,	GPIOD + 0x00	//set GPIO pin mode as Input/Output/Analog
	// ...

