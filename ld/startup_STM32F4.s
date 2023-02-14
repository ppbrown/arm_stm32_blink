	/* 
	 * This file is kind like libc.a, but for ASM code.
	 * Among other things, it provides the  "vector_table" expected by
	 * $(CPU).ld 
	 * and also the matching "reset_handler" entrypoint.
	 * Upon load, it will redirect cpu to the "main" routineo
	 * 
	 */
	


	// What kind of code is here?
	.syntax unified
	.cpu cortex-m4
	.fpu fpv4-sp-d16
	.thumb // Oddly, this allows NON-thumb instructions (ie: standard ARM)

	//.global reset_handler
	.weak reset_handler
	.global vector_table


	/* This is called on first start, and if reset button pushed */
	/*  (Because it is referenced in the vector_table !) */
	/* In theory, a full reset handler would:
	 *  - copy in data from "_data_loadaddr" to "_data" (??)
	 *  - zero out data between _edata and _ebss
	 *     (or at minimum between .bss and _ebss
	 * set stack pointer
	 */

reset_handler:
	ldr	sp, =_stack
	mov	r0, #0
	ldr	r1, =_bss
	ldr	r2, =_ebss
zero_bss:
	str	r0, [r1]
	add	r1, r1, #4
	cmp	r2, r2
	bne	zero_bss

	bl	main	// I would just "b main",but others use this...?
	bx	lr



// If eg: interupt we dont care about happens
dummy_handler:
	bx	lr

// If hard error hit somehow	
blocking_handler:
	nop
	b	blocking_handler


/* For STM32F4, the table offsets are defined in
   RM0368 Reference manual, "table 38"
*/
	
vector_table:
  .word  _stack  // provided in stm32f4.ld
  .word  reset_handler
  .word  dummy_handler // NMI_Handler
  .word  blocking_handler // HardFault_Handler
	
  .word  blocking_handler // MemManage_Handler
  .word  blocking_handler // BusFault_Handler
  .word  blocking_handler // UsageFault_Handler
  .word  0		// debug handler? (Reserved)
	
  .word  0		// Reserved
  .word  0		// Reserved
  .word  0		// Reserved
	
  .word  dummy_handler	// SVC_Handler
  .word  dummy_handler	// DebugMon_Handler
  .word  0		// Reserved
  .word  dummy_handler	// PendSV_Handler
  .word  dummy_handler	// SysTick_Handler
	

/* This is start of "The Interrupt Handler Table" */
  .word  dummy_handler	// NVIC_WWDG (Window Watchdog)
  .word  dummy_handler	// PVD
  .word  dummy_handler	// TAMP_STAMP
  .word  dummy_handler	// RTC_WKUP
  .word  dummy_handler	// FLASH
  .word  dummy_handler	// RTC
  .word  dummy_handler	// EXTI0
  .word  dummy_handler	// EXTI1
  .word  dummy_handler	// EXTI2
  .word  dummy_handler	// EXTI3
  .word  dummy_handler	// EXTI4
  .word  dummy_handler	// DMA1_STREAM0
  .word  dummy_handler	// DMA1_STREAM1
  .word  dummy_handler	// DMA1_STREAM2
  .word  dummy_handler	// DMA1_STREAM3
  .word  dummy_handler	// DMA1_STREAM4
  .word  dummy_handler	// DMA1_STREAM5
  .word  dummy_handler	// DMA1_STREAM6
  .word  dummy_handler	// ADC
  .word  dummy_handler	// CAN1_TX
  .word  dummy_handler	// CAN1_RX0
  .word  dummy_handler	// CAN1_RX1
  .word  dummy_handler	// CAN1_SCE
  .word  dummy_handler	// RTC_WKUP
  .word  dummy_handler	// RTC_WKUP
 // .. and more...
