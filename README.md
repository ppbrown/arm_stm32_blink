# Blink demo for stm32f4 series ARM chip, in pure Assembly Language

This is intended to be a starting point for general-case 
Embedded ARM Assembly Programming

This demo is specifically coded on a stm32f401re CPU,
(Cortex M4)
shipped on a Nucleo-F-401RE board with an LED, sold by
ST Microelectronics
* https://www.st.com/en/microcontrollers-microprocessors/stm32f4-series.html
* https://www.st.com/en/microcontrollers-microprocessors/stm32f401.html
* https://www.st.com/en/evaluation-tools/nucleo-f401re.html
* https://os.mbed.com/platforms/ST-Nucleo-F401RE/

(Note: now also supports Nucleo-L476RG, which is stm32l476 based)

There are now multiple choices for C-code development, for ARM chips.
"Keil", or STM's "CubeIDE" are just two of them. However, they arent
friendly to Assembly Language development.
Keil is the more usable in that sense, but officially, it is ms-windows only.

This project is sharing an example of a pure GNU-toolchain based solution
to writing ASM code for ARM chips.
Additionally, it is targetted for Linux as the developer desktop

(using a crosscompiler, not "linux on arm" desktop)

# Files of interest

In this directory you should find the following files:
    (substitute as needed for l4 instead of f4)

Simple blink program

* blink_inc.s          - the main code of interest
* blink_stm32f4.s      - the cpu-specific entrypoint

Button driven blink program

* press_inc.s          - the main code of interest
* press_stm32f4.s      - the cpu-specific entrypoint


Common definitions

* startup_stm32f4.s    - kinda like libc.a, but for ASM
* regs_stm32f4_inc.s   - cpu-specific defs included by the main code.
* stm32f4.ld           - special defs required by the link stage

# How to compile

Make sure you the GNU Arm cross-compiling toolchain.
One way is to use the packages provided by the STM folks.
(it installs under /opt/st)

Another way, if you have ubuntu, is to simply do

    apt install gcc-arm-none-eabi gdb-arm-none-eabi stlink
    (or stlink-gui)

# How to run (Pure Linux Text Terminal)

First, you need to start up the "st-util" program in the background,
or from a separate window.

For convenience, you'll probably want to make a script wrapper, "gdb-debug":
    
    pgrep st-util >/dev/null || {
    echo st-util is required;  exit 1
    }

    if ! test -f "$1" ; then
    echo ERROR: need to specify file.elf
    exit 1
    fi


    gdb-multiarch -q -ex 'set architecture armv7' \
	-ex 'target extended-remote localhost:4242' \
	-ex 'load '$1 -ex 'file '$1
	

Then in a window you want to debug in, you can then run

	gdb-debug blink_stm32f4.elf
	
and do typical gdb debugging things. You might want to do something like

	layout regs
	next
	next   (note that pressing "return" repeats next)




# GDB Multilink annoyance:

If you use the ubuntu packaged gdb instead of the STM tweaked version,
you have to "set arch arm" explicitly. So you might want to install the ST.com
"Cube" IDE package, even if you dont use their IDE.

and it seems slower.

# Original inspiration

At this point, it's pretty much all my code. However, my original
experiments were inspired by the following mostly C-based programs

https://github.com/jrsa/stm32f4_blink         (C-code based blink app)

https://github.com/libopencm3/libopencm3/     (library used by above)

https://github.com/libopencm3/libopencm3-miniblink  (multiple hardware device blink)

https://gist.github.com/BobBurns/bb601d3432650073a8b4  "blinky.s" for Discovery stm32L1


# Contributing

I think i have made this somewhat extensible.
If for some reason you want to contribute straight ASM versions of the files for 
your own ARM board, feel free to put up a PR, and I'll be happy to review and
consider it for inclusion, giving you credit

