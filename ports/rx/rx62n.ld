/*
    GNU linker script for RX62N
*/

/* Specify the memory areas */
MEMORY
{
    FLASH (rx)      : ORIGIN = 0xfff80000, LENGTH = 0x00080000 - 0x80 /* 512 KiB */
    VECTOR (r)      : ORIGIN = 0xffffff80, LENGTH = 0x00000080
    RAM (xrw)       : ORIGIN = 0x00000000, LENGTH = 0x00018000 /* 96 KiB */
}

/* top end of the stack */
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* define output sections */
SECTIONS
{
    /* The program code and other data goes into FLASH */
    .text :
    {
        . = ALIGN(4);
	*(P)
        *(.text)          /* .text* sections (code) */
        *(.text.*)          /* .text* sections (code) */
	*(C)
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */

        . = ALIGN(4);
        _etext = .;        /* define a global symbol at end of code */
        _sidata = _etext;  /* This is used by the startup in order to initialize the .data secion */
    } >FLASH

    .vector :
    {
	*(.vector)
    } > VECTOR

    /* This is the initialized data section
    The program executes knowing that the data is in the RAM
    but the loader puts the initial values in the FLASH (inidata).
    It is one task of the startup to copy the initial values from FLASH to RAM. */
    .data : AT ( _sidata )
    {
        . = ALIGN(4);
        _sdata = .;        /* create a global symbol at data start; used by startup code in order to initialise the .data section in RAM */
        *(.data*)          /* .data* sections */

        . = ALIGN(4);
        _edata = .;        /* define a global symbol at data end; used by startup code in order to initialise the .data section in RAM */
    } >RAM

    /* Uninitialized data section */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;         /* define a global symbol at bss start; used by startup code */
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);
        _ebss = .;         /* define a global symbol at bss end; used by startup code */
    } >RAM
}
