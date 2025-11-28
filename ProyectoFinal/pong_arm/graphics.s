/* graphics.s - Graphics module with double buffering */

.global lcd_init
.global clear_buffer
.global draw_rect
.global swap_buffers
.global get_back_buffer

/* Screen dimensions */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480

/* PL110 LCD Controller registers */
.equ LCD_BASE, 0x10120000
.equ LCD_TIMING0, 0x00
.equ LCD_TIMING1, 0x04
.equ LCD_TIMING2, 0x08
.equ LCD_UPBASE, 0x10
.equ LCD_CONTROL, 0x18

/* Framebuffers */
.equ FRAMEBUFFER_FRONT, 0x00200000
.equ FRAMEBUFFER_BACK, 0x00300000

/* Colors (RGB565) */
.equ COLOR_BLACK, 0x0000
.equ COLOR_WHITE, 0xFFFF

.section .data
current_back_buffer: .word FRAMEBUFFER_BACK

.section .text

/* Initialize LCD Controller */
lcd_init:
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str lr, [sp, #16]
    
    ldr r0, =LCD_BASE
    
    /* Timing 0: Horizontal timing */
    ldr r1, =0x3F1F3F9C
    str r1, [r0, #LCD_TIMING0]
    
    /* Timing 1: Vertical timing */
    ldr r1, =0x080B61DF
    str r1, [r0, #LCD_TIMING1]
    
    /* Timing 2: Clock and signal polarity */
    ldr r1, =0x067F1800
    str r1, [r0, #LCD_TIMING2]
    
    /* Set framebuffer base address (front buffer) */
    ldr r1, =FRAMEBUFFER_FRONT
    str r1, [r0, #LCD_UPBASE]
    
    /* Control: Enable, 16bpp 565 mode, TFT */
    ldr r1, =0x1829
    str r1, [r0, #LCD_CONTROL]
    
    /* Clear both buffers */
    ldr r0, =FRAMEBUFFER_FRONT
    bl clear_buffer_at_address
    ldr r0, =FRAMEBUFFER_BACK
    bl clear_buffer_at_address
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr lr, [sp, #16]
    add sp, sp, #20
    mov pc, lr

/* Get back buffer address */
/* Returns address in r0 */
get_back_buffer:
    ldr r0, =current_back_buffer
    ldr r0, [r0]
    mov pc, lr

/* Clear back buffer to black */
clear_buffer:
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str lr, [sp, #16]
    
    bl get_back_buffer
    bl clear_buffer_at_address
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr lr, [sp, #16]
    add sp, sp, #20
    mov pc, lr

/* Clear buffer at specific address */
/* r0 = buffer address */
clear_buffer_at_address:
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str lr, [sp, #16]
    
    ldr r1, =COLOR_BLACK
    ldr r2, =(SCREEN_WIDTH * SCREEN_HEIGHT)
    
clear_loop:
    strh r1, [r0], #2
    sub r2, r2, #1
    cmp r2, #0
    bne clear_loop
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr lr, [sp, #16]
    add sp, sp, #20
    mov pc, lr

/* Swap buffers (copy back to front) */
swap_buffers:
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str lr, [sp, #16]
    
    ldr r0, =FRAMEBUFFER_FRONT
    ldr r1, =FRAMEBUFFER_BACK
    ldr r2, =(SCREEN_WIDTH * SCREEN_HEIGHT)
    
copy_loop:
    ldrh r3, [r1], #2
    strh r3, [r0], #2
    sub r2, r2, #1
    cmp r2, #0
    bne copy_loop
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr lr, [sp, #16]
    add sp, sp, #20
    mov pc, lr

/* Draw filled rectangle to back buffer */
/* r0 = x, r1 = y, r2 = width, r3 = height, r4 = color */
draw_rect:
    sub sp, sp, #40
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    str r5, [sp, #20]
    str r6, [sp, #24]
    str r7, [sp, #28]
    str r8, [sp, #32]
    str lr, [sp, #36]
    
    mov r5, r1                  /* r5 = current Y */
    add r6, r1, r3              /* r6 = end Y */
    
draw_rect_y_loop:
    cmp r5, r6
    bge draw_rect_done
    
    mov r7, r0                  /* r7 = current X */
    add r8, r0, r2              /* r8 = end X */
    
draw_rect_x_loop:
    cmp r7, r8
    bge draw_rect_next_y
    
    /* Calculate pixel address in back buffer */
    /* Save r0-r4 manually */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    
    mov r0, r7                  /* X */
    mov r1, r5                  /* Y */
    bl get_pixel_address_back
    strh r4, [r0]               /* Write color */
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    add r7, r7, #1
    b draw_rect_x_loop
    
draw_rect_next_y:
    add r5, r5, #1
    b draw_rect_y_loop
    
draw_rect_done:
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    ldr r5, [sp, #20]
    ldr r6, [sp, #24]
    ldr r7, [sp, #28]
    ldr r8, [sp, #32]
    ldr lr, [sp, #36]
    add sp, sp, #40
    mov pc, lr

/* Get pixel address in back buffer */
/* r0 = x, r1 = y */
/* Returns address in r0 */
get_pixel_address_back:
    sub sp, sp, #16
    str r1, [sp, #0]
    str r2, [sp, #4]
    str r3, [sp, #8]
    str lr, [sp, #12]
    
    ldr r2, =SCREEN_WIDTH
    mul r3, r1, r2              /* y * width */
    add r3, r3, r0              /* + x */
    mov r3, r3, lsl #1          /* * 2 (16-bit pixels) */
    
    bl get_back_buffer
    add r0, r0, r3
    
    ldr r1, [sp, #0]
    ldr r2, [sp, #4]
    ldr r3, [sp, #8]
    ldr lr, [sp, #12]
    add sp, sp, #16
    mov pc, lr