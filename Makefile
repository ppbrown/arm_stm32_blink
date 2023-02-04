
CPU=stm32f4
#CPU=stm32l4


CFLAGS=-g  -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16


#LDFLAGS=-L./libopencm3/lib -L. -lopencm3_stm32f4 

LDFILE=-T$(CPU).ld
#LDFILE=-Tnucleo-f401re.ld

all:	$(CPU)_blink.elf


# The ASM files are so small, no point in having an intermediate
# compile step for .o

stm32f4_blink.elf: Makefile stm32f4_blink.s $(CPU)_inc.s $(CPU)_base.s $(CPU).ld 
	arm-none-eabi-gcc --static -nostartfiles $(LDFILE) \
	-mthumb $(CFLAGS)  $(LDFLAGS) \
	stm32f4_blink.s $(CPU)_base.s -o $@

stm32l4_blink.elf: Makefile stm32l4_blink.s $(CPU)_inc.s $(CPU)_base.s $(CPU).ld 
	arm-none-eabi-gcc --static -nostartfiles $(LDFILE) \
	-mthumb $(CFLAGS)  $(LDFLAGS) \
	stm32l4_blink.s $(CPU)_base.s -o $@



# When I was doing my original port from other people's C code,
# this was really useful: It disassembled the C code to ASM,
# so I could see how they handled some things at the ASM level.

#stm32f4_blink.dump: stm32f4_blink.elf stm32f4_blink.s main.c
#	arm-none-eabi-objdump -h -S  stm32f4_blink.elf  > "stm32f4_blink.dump"

stm32f4_blink.bin: stm32f4_blink.elf
	arm-none-eabi-objcopy  -O binary  stm32f4_blink.elf  "stm32f4_blink.bin"


clean:
	rm -f stm32f4_blink.elf stm32f4_blink.dump stm32f4_blink.bin
