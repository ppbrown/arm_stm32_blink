
# To change the value, you can either edit this file,
# or just make with   "make CPU=stm32l4"
CPU=stm32f4
#CPU=stm32l4


CFLAGS=-g  -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16


#LDFLAGS=-L./libopencm3/lib -L. -lopencm3_stm32f4 

LDFILE=-T$(CPU).ld
#LDFILE=-Tnucleo-f401re.ld

all:	blink_$(CPU).elf press_$(CPU).elf


# The ASM files are so small, no point in having an intermediate
# compile step for .o

blink_$(CPU).elf: Makefile blink_$(CPU).s blink_inc.s regs_$(CPU)_inc.s startup_$(CPU).s $(CPU).ld 
	arm-none-eabi-gcc --static -nostartfiles $(LDFILE) \
	-mthumb $(CFLAGS)  $(LDFLAGS) \
	blink_$(CPU).s startup_$(CPU).s -o $@

press_$(CPU).elf: Makefile press_$(CPU).s press_inc.s regs_$(CPU)_inc.s startup_$(CPU).s $(CPU).ld 
	arm-none-eabi-gcc --static -nostartfiles $(LDFILE) \
	-mthumb $(CFLAGS)  $(LDFLAGS) \
	press_$(CPU).s startup_$(CPU).s -o $@



# When I was doing my original port from other people's C code,
# this dump was really useful: It disassembled the C code to ASM,
# so I could see how they handled some things at the ASM level.

#blink_$(CPU).dump: blink_$(CPU).elf blink_$(CPU).s main.c
#	arm-none-eabi-objdump -h -S  blink_$(CPU).elf  > $@


# this is in theory for direct loads with st-flash.
# however, it is missing something to make it work that way.
blink_$(CPU).bin: blink_$(CPU).elf
	arm-none-eabi-objcopy  -O binary  blink_$(CPU).elf  $@

press_$(CPU).bin: blink_$(CPU).elf
	arm-none-eabi-objcopy  -O binary  blink_$(CPU).elf  $@


clean:
	rm -f *.elf *.dump *.bin
