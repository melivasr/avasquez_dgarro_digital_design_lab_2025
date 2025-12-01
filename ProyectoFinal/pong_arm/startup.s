/* startup.s - ARM startup code for Pong game */

.global _start

.section .text
_start:
    /* Set up stack pointer */
    ldr sp, =stack_top
    
    /* Initialize LCD controller */
    bl lcd_init
    
    /* Branch to main game */
    bl pong_main
    
    /* Halt if main returns */
halt:
    b halt

.section .bss
    .space 8192
stack_top: