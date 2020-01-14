# The Renesas RX port

This port is intended to be a minimal MicroPython port that actually runs.
It can run under Linux (or similar) and on any RX MCU (eg the pyboard).

## Building for an RX

The Makefile has the ability to build for a RX CPU and also enables a SCI
for communication.  To build:

    $ make CROSS=1

If you previously built the Linux version, you will need to first run
`make clean` to get rid of incompatible object files.

## Building without the built-in MicroPython compiler

This minimal port can be built with the built-in MicroPython compiler
disabled.  This will reduce the firmware by about 20k on a Thumb2 machine,
and by about 40k on 32-bit x86.  Without the compiler the REPL will be
disabled, but pre-compiled scripts can still be executed.

To test out this feature, change the `MICROPY_ENABLE_COMPILER` config
option to "0" in the mpconfigport.h file in this directory.  Then
recompile and run the firmware and it will execute the frozentest.py
file.
