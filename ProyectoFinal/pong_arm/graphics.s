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
    push {r0-r3, lr}
    
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
    
    pop {r0-r3, pc}

/* Get back buffer address */
/* Returns address in r0 */
get_back_buffer:
    ldr r0, =current_back_buffer
    ldr r0, [r0]
    mov pc, lr

/* Clear back buffer to black */
clear_buffer:
    push {r0-r3, lr}
    
    bl get_back_buffer
    bl clear_buffer_at_address
    
    pop {r0-r3, pc}

/* Clear buffer at specific address */
/* r0 = buffer address */
clear_buffer_at_address:
    push {r0-r3, lr}
    
    ldr r1, =COLOR_BLACK
    ldr r2, =(SCREEN_WIDTH * SCREEN_HEIGHT)
    
clear_loop:
    strh r1, [r0], #2
    subs r2, r2, #1
    bne clear_loop
    
    pop {r0-r3, pc}

/* Swap buffers (copy back to front) */
swap_buffers:
    push {r0-r3, lr}
    
    ldr r0, =FRAMEBUFFER_FRONT
    ldr r1, =FRAMEBUFFER_BACK
    ldr r2, =(SCREEN_WIDTH * SCREEN_HEIGHT)
    
copy_loop:
    ldrh r3, [r1], #2
    strh r3, [r0], #2
    subs r2, r2, #1
    bne copy_loop
    
    pop {r0-r3, pc}

/* Draw filled rectangle to back buffer */
/* r0 = x, r1 = y, r2 = width, r3 = height, r4 = color */
draw_rect:
    push {r0-r8, lr}
    
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
    push {r0-r4}
    mov r0, r7                  /* X */
    mov r1, r5                  /* Y */
    bl get_pixel_address_back
    strh r4, [r0]               /* Write color */
    pop {r0-r4}
    
    add r7, r7, #1
    b draw_rect_x_loop
    
draw_rect_next_y:
    add r5, r5, #1
    b draw_rect_y_loop
    
draw_rect_done:
    pop {r0-r8, pc}

/* Get pixel address in back buffer */
/* r0 = x, r1 = y */
/* Returns address in r0 */
get_pixel_address_back:
    push {r1-r3, lr}
    
    ldr r2, =SCREEN_WIDTH
    mul r3, r1, r2              /* y * width */
    add r3, r3, r0              /* + x */
    lsl r3, r3, #1              /* * 2 (16-bit pixels) */
    
    bl get_back_buffer
    add r0, r0, r3
    
    pop {r1-r3, pc}
    