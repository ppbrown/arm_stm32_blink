
# Porting this code to other hardware

Lets say you have some similar-but-different ARM32 hardware 
(easiest would be another STM manufactured board), and you want to
have your own ASM blinker program.

One way to approach this, is similar to how I did the original port:
Find C code that does the blink, then substutite functions bit by bit.

But, if you cant, or dont want to do that, then the strategy would be:

1. Get technical spec on your hardware, with full register address details

2. Create a version of include/regs_STM32F4_inc.s for your own hardware, 
substituting values as appropriate. (more on that lower down)

For example, my board focuses around GPIOA, but many other boards
instead use GPIOB for the onboard LED(s)

3. Adjust the mainline ASM code to do the setup and blink calls appropriate
for your hardware


# Key Register values

90% of the register definitions will be identical for all ARM STM32 boards.

Currently I support two diferent boards, based around: STM32F4 and STM32L4

If you diff the include/reg files for those two, you will see that only a 
few key values are different:

+ PERIPH_BASE_AHB2  
+ RCC_BASE 
+ AHBxENR_OFFSET 
+ RCC_GPIO_ENABLER 
+ GPIO_BASE 

So, if you copy one of the existing reg_ files to a new file, and make sure
those values are set appropriate to your hardware... AND then also
update *regs_inc.S* to have a matching clause, then you should have all that is 
needed to support your own hardware varient.

## GDB tips

I should first say that there is an alleged GUI tool to help with this,
called "inspire", I think.
I used just straight gdb on command line.

That being said, gdb has some features that werent there when I learned
it.  There is a "layout" command, that almost turns it into a Text UI.
It gives you multi-"window" display, with options to show register state,
original source, or mixed src+asm. Example

    layout split

