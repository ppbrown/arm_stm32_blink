# Porting guide

This guide has three parts:
A historical part of how I turned C versions into ASM,
tips if you want to take this code and port it to another ARM platform,
and some tips on using GDB from commandline


## Porting History

I learned ASM programming a long time ago (on a platform far, far away)
so I was very rusty in every way. I couldnt just jump straight in.
The embedded ARM platform has very little feedback, other than the magic
blinky light, and to have the light blink is a multi step process.
When I tried to just grab asm from another ARM platform, it didnt work,
and I had no idea which part(s) needed help.

### Modular testing

Eventually I decided to pick some working C code, and port it piece by
piece. This has the advantage of modularity: If I only added a small module
at one time, I knew which code needed to be fixed.
So, "gpio_toggle()" became "asm_gpio_toggle", and so on.

### Start by Streamlining

The original C code, using the libopencm3 library, has thousands and
thousands of defines, because it supports possibly 100 hardware varients.
This makes its define structure kind of function-oriented, which makes
it challenging to port to ASM.

Because of this, I decided to pull in all the defines used into the C file
itself, and remove the #includes for them.

Once I had done this, and the C code still compiled, I knew I had all I
needed to port the functionality, in the one file.

### Simplify nested defines

As mentioned, libopencm3 supports many many hardware varients.
As such, they have a lot of nested #defines. 
If they are constant based, AND you change your source code file
to be named ".S" instead of ".s", you might actually be able to use
a lot of them as-is.

Some of them are overly difficult to truely understand, unless you unwind them.
Example:

	#define PERIPH_BASE        (0x40000000U)
	#define PERIPH_BASE_AHB1   (PERIPH_BASE + 0x20000)
	#define GPIO_PORT_A_BASE   (PERIPH_BASE_AHB1 + 0x0000)
	#define GPIOA              GPIO_PORT_A_BASE
	
Really??? All that, just for "GPIOA = 0x40020000" ?
Technically, since theres no extensive use of variables and types, you can
actually use the above as-is, as long as you name your source file with ".S"

However, if you want to preserve the original nesting, AND you want to 
use traditional ".s", you can do it with

	.equ PERIPH_BASE,       (0x40000000U)
	.equ PERIPH_BASE_AHB1,  (PERIPH_BASE + 0x20000)
	.equ GPIO_PORT_A_BASE,  (PERIPH_BASE_AHB1 + 0x0000)
	.equ GPIOA,              GPIO_PORT_A_BASE



## Porting this code to other hardware

Lets say you have a similar-but-different ARM32 hardware, and you want to
have your own ASM blinker.

One way to approach this, is similar to how I did the original port:
Find C code that does the blink, then substutite functions bit by bit.

But, if you cant, or dont want to do that, then the strategy would be:

1. Get technical spec on your hardware, with full register address details

2. Create a version of stm32f4_regs_inc.s for your own hardware, substututing
values as appropriate.

For example, my board focuses around GPIOA, but many other boards
instead use GPIOB for the onboard LED(s)

3. Adjust the mainline ASM code to do the setup and blink calls appropriate
for your hardware



## GDB tips

I should first say that there is an alleged GUI tool to help with this,
called "inspire", I think.
I used just straight gdb on command line.

That being said, gdb has some features that werent there when I learned
it.  There is a "layout" command, that almost turns it into a Text UI.
It gives you multi-"window" display, with options to show register state,
original source, or mixed src+asm. Example

    layout split

