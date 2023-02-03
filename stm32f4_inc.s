	
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
microcontroller.

	
// ******* Register definitions *******

	.equ	PERIPH_BASE, 0x40000000U
	.equ	PERIPH_BASE_AHB1,PERIPH_BASE + 0x20000
	.equ	RCC_BASE, PERIPH_BASE_AHB1 + 0x3800

	
	.equ	RCC_AHB1ENR,	0x40023830	//Clock control for AHB1 peripherals (includes GPIO)


	// #define _REG_BIT(base, bit)		(((base) << 5) + (bit))
	// RCC_GPIOA       = _REG_BIT(0x30, 0),

	.equ	RCC_GPIOA, 0x30 <<5

	// #define _RCC_REG(i)             MMIO32(RCC_BASE + ((i) >> 5))
	// #define _RCC_BIT(i)             (1 << ((i) & 0x1f))

	// rcc_periph_clock_enable(RCC_GPIOA);
        // _RCC_REG(RCC_GPIOA) |= _RCC_BIT(RCC_GPIOA);

	.equ	RCC_REG_GPIOA, RCC_BASE + 0x30
	.equ	RCC_BIT_GPIOA, 1 << ((0x30 <<5) & 0x1f)



	/*************************************************************************/
	/*   ......   GPIO Section .......                                       */
	/*************************************************************************/
	
	.equ	GPIOA, 0x40020000	// GPIO port A (also "Base")
	.equ	GPIOB, 0x40020400	// GPIO port B (also "Base")
	.equ	GPIOC, 0x40020800	// GPIO port C (also "Base")
	.equ	GPIOD, 0x40020C00	// GPIO port D (also "Base")
	.equ	GPIOE, 0x40021000	// GPIO port E (also "Base")
	.equ	GPIOF, 0x40021400	// GPIO port F (also "Base")

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
	.equ	GPIOA_MODER,	0x40020000	//set GPIO pin mode as Input/Output/Analog
	.equ	GPIOA_OTYPER,	0x40020004	//Set GPIO pin type as push-pull or open drain
	.equ	GPIOA_OSPEEDR,	0x40020008	//Set GPIO pin switching speed
	.equ	GPIOA_PUPDR,	0x4002000C	//Set GPIO pin pull-up/pull-down
	.equ	GPIOA_ODR,  0x40020014	//GPIO pin output data
	.equ	GPIOA_BSRR, 0x40020018	// Bit Set/Reset


//GPIO-B control registers
	.equ	GPIOB_MODER,	0x40020400	//set GPIO pin mode as Input/Output/Analog
	// ...
//GPIO-C control registers
	.equ	GPIOC_MODER,	0x40020800	//set GPIO pin mode as Input/Output/Analog
	// ...
	
//GPIO-D control registers
	.equ	GPIOD_MODER,	0x40020C00	//set GPIO pin mode as Input/Output/Analog
	// ...

