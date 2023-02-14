

// You MUST   #include this file, NOT use .include
	
// It is required that you define at least one CPU type
// Then we include the matching register file, which
// will have homogeonized definitions


#if defined(STM32F4)
 	.include "include/regs_STM32F4_inc.s"
#elif defined(STM32L4)
	.include "include/regs_STM32L4_inc.s"
#else
#error You must define one STMxxx cpu type
#endif


