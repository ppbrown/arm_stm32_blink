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
	/* In theory, a full reset handler would zero out stack,etc. */
	/* but we dont really need it for this, and I'm lazy. */

reset_handler:
	b	main

vector_table:
  .word  _stack  // provided in stm32f4.ld
  .word  reset_handler
  .word  // NMI_Handler
  .word  // HardFault_Handler
  .word  // MemManage_Handler
  .word  // BusFault_Handler
  .word  // UsageFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  // SVC_Handler
  .word  // DebugMon_Handler
  .word  0
  .word  // PendSV_Handler
  .word  // SysTick_Handler
	

	/* in theory, would have an interrupt-handler table here */
