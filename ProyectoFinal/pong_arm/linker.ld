/* linker.ld - Linker script for QEMU versatilepb */

ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x00010000, LENGTH = 128M
}

SECTIONS
{
    .text : {
        *(.text)
    } > RAM
    
    .rodata : {
        *(.rodata)
    } > RAM
    
    .data : {
        *(.data)
    } > RAM
    
    .bss : {
        *(.bss)
    } > RAM
}
