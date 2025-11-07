/* pong.s - Pong game implementation for ARMv4 */

.global pong_main
.global lcd_init

/* Screen dimensions */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480

/* PL110 LCD Controller registers for versatilepb */
.equ LCD_BASE, 0x10120000
.equ LCD_TIMING0, 0x00
.equ LCD_TIMING1, 0x04
.equ LCD_TIMING2, 0x08
.equ LCD_UPBASE, 0x10
.equ LCD_CONTROL, 0x18

/* Framebuffer address */
.equ FRAMEBUFFER, 0x00200000

/* Game constants */
.equ PADDLE_WIDTH, 10
.equ PADDLE_HEIGHT, 60
.equ BALL_SIZE, 8
.equ PADDLE_SPEED, 5
.equ BALL_SPEED, 3

/* Colors (RGB565) */
.equ COLOR_BLACK, 0x0000
.equ COLOR_WHITE, 0xFFFF
.equ COLOR_PADDLE, 0x07E0    /* Green */
.equ COLOR_BALL, 0xF800      /* Red */

/* Keyboard/UART base */
.equ UART0_BASE, 0x101f1000
.equ UART_DR, 0x00
.equ UART_FR, 0x18
.equ UART_FR_RXFE, 0x10      /* Receive FIFO empty */

/* Game state variables in memory */
.section .data
    .align 4
paddle1_y: .word 210         /* Left paddle Y position */
paddle2_y: .word 210         /* Right paddle Y position */
ball_x: .word 320            /* Ball X position */
ball_y: .word 240            /* Ball Y position */
ball_dx: .word 3             /* Ball X velocity */
ball_dy: .word 2             /* Ball Y velocity */

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
    
    /* Set framebuffer base address */
    ldr r1, =FRAMEBUFFER
    str r1, [r0, #LCD_UPBASE]
    
    /* Control: Enable, 16bpp 565 mode, TFT */
    ldr r1, =0x1829
    str r1, [r0, #LCD_CONTROL]
    
    pop {r0-r3, pc}

/* Main game loop */
pong_main:
    push {r4-r11, lr}
    
    /* Clear screen initially */
    bl clear_screen
    
game_loop:
    /* Handle input */
    bl handle_input
    
    /* Update ball position */
    bl update_ball
    
    /* Check collisions */
    bl check_collisions
    
    /* Clear screen */
    bl clear_screen
    
    /* Draw paddles */
    bl draw_paddles
    
    /* Draw ball */
    bl draw_ball
    
    /* Small delay */
    bl delay
    
    /* Loop forever */
    b game_loop
    
    pop {r4-r11, pc}

/* Clear screen to black */
clear_screen:
    push {r0-r3, lr}
    
    ldr r0, =FRAMEBUFFER
    ldr r1, =COLOR_BLACK
    ldr r2, =(SCREEN_WIDTH * SCREEN_HEIGHT)
    
clear_loop:
    strh r1, [r0], #2
    subs r2, r2, #1
    bne clear_loop
    
    pop {r0-r3, pc}

/* Handle keyboard input */
handle_input:
    push {r0-r3, lr}
    
    ldr r0, =UART0_BASE
    
    /* Check if data available */
    ldr r1, [r0, #UART_FR]
    tst r1, #UART_FR_RXFE
    bne input_done              /* No input available */
    
    /* Read character */
    ldrb r2, [r0, #UART_DR]
    
    /* Check for 'w' - paddle1 up */
    cmp r2, #'w'
    bne check_s
    ldr r0, =paddle1_y
    ldr r1, [r0]
    subs r1, r1, #PADDLE_SPEED
    cmp r1, #0
    movlt r1, #0
    str r1, [r0]
    b input_done
    
check_s:
    /* Check for 's' - paddle1 down */
    cmp r2, #'s'
    bne check_up
    ldr r0, =paddle1_y
    ldr r1, [r0]
    add r1, r1, #PADDLE_SPEED
    ldr r3, =(SCREEN_HEIGHT - PADDLE_HEIGHT)
    cmp r1, r3
    movgt r1, r3
    str r1, [r0]
    b input_done
    
check_up:
    /* Check for up arrow (could be 'i') - paddle2 up */
    cmp r2, #'i'
    bne check_down
    ldr r0, =paddle2_y
    ldr r1, [r0]
    subs r1, r1, #PADDLE_SPEED
    cmp r1, #0
    movlt r1, #0
    str r1, [r0]
    b input_done
    
check_down:
    /* Check for down arrow (could be 'k') - paddle2 down */
    cmp r2, #'k'
    bne input_done
    ldr r0, =paddle2_y
    ldr r1, [r0]
    add r1, r1, #PADDLE_SPEED
    ldr r3, =(SCREEN_HEIGHT - PADDLE_HEIGHT)
    cmp r1, r3
    movgt r1, r3
    str r1, [r0]
    
input_done:
    pop {r0-r3, pc}

/* Update ball position */
update_ball:
    push {r0-r3, lr}
    
    /* Update X position */
    ldr r0, =ball_x
    ldr r1, [r0]
    ldr r2, =ball_dx
    ldr r3, [r2]
    add r1, r1, r3
    str r1, [r0]
    
    /* Update Y position */
    ldr r0, =ball_y
    ldr r1, [r0]
    ldr r2, =ball_dy
    ldr r3, [r2]
    add r1, r1, r3
    str r1, [r0]
    
    pop {r0-r3, pc}

/* Check collisions */
check_collisions:
    push {r0-r5, lr}
    
    /* Check top/bottom walls */
    ldr r0, =ball_y
    ldr r1, [r0]
    cmp r1, #0
    ble bounce_y
    ldr r2, =(SCREEN_HEIGHT - BALL_SIZE)
    cmp r1, r2
    bge bounce_y
    b check_paddles
    
bounce_y:
    ldr r0, =ball_dy
    ldr r1, [r0]
    rsb r1, r1, #0              /* Negate velocity */
    str r1, [r0]
    
check_paddles:
    ldr r0, =ball_x
    ldr r1, [r0]                /* r1 = ball_x */
    ldr r2, =ball_y
    ldr r3, [r2]                /* r3 = ball_y */
    
    /* Check left paddle collision */
    cmp r1, #30
    bgt check_right_paddle
    cmp r1, #10
    blt reset_ball              /* Missed - point for player 2 */
    
    ldr r4, =paddle1_y
    ldr r5, [r4]                /* r5 = paddle1_y */
    cmp r3, r5
    blt check_right_paddle
    add r5, r5, #PADDLE_HEIGHT
    cmp r3, r5
    bgt check_right_paddle
    
    /* Collision with left paddle */
    ldr r0, =ball_dx
    ldr r1, [r0]
    rsb r1, r1, #0
    str r1, [r0]
    b collision_done
    
check_right_paddle:
    ldr r1, =ball_x
    ldr r2, [r1]
    ldr r4, =(SCREEN_WIDTH - 30)
    cmp r2, r4
    blt collision_done
    ldr r4, =(SCREEN_WIDTH - 10)
    cmp r2, r4
    bgt reset_ball              /* Missed - point for player 1 */
    
    ldr r4, =paddle2_y
    ldr r5, [r4]
    cmp r3, r5
    blt collision_done
    add r5, r5, #PADDLE_HEIGHT
    cmp r3, r5
    bgt collision_done
    
    /* Collision with right paddle */
    ldr r0, =ball_dx
    ldr r1, [r0]
    rsb r1, r1, #0
    str r1, [r0]
    b collision_done
    
reset_ball:
    /* Reset ball to center */
    ldr r0, =ball_x
    ldr r1, =(SCREEN_WIDTH / 2)
    str r1, [r0]
    ldr r0, =ball_y
    ldr r1, =(SCREEN_HEIGHT / 2)
    str r1, [r0]
    
collision_done:
    pop {r0-r5, pc}

/* Draw paddles */
draw_paddles:
    push {r0-r5, lr}
    
    /* Draw left paddle */
    mov r0, #20                 /* X position */
    ldr r1, =paddle1_y
    ldr r1, [r1]                /* Y position */
    ldr r2, =PADDLE_WIDTH
    ldr r3, =PADDLE_HEIGHT
    ldr r4, =COLOR_PADDLE
    bl draw_rect
    
    /* Draw right paddle */
    ldr r0, =(SCREEN_WIDTH - 20 - PADDLE_WIDTH)
    ldr r1, =paddle2_y
    ldr r1, [r1]
    ldr r2, =PADDLE_WIDTH
    ldr r3, =PADDLE_HEIGHT
    ldr r4, =COLOR_PADDLE
    bl draw_rect
    
    pop {r0-r5, pc}

/* Draw ball */
draw_ball:
    push {r0-r5, lr}
    
    ldr r0, =ball_x
    ldr r0, [r0]
    ldr r1, =ball_y
    ldr r1, [r1]
    ldr r2, =BALL_SIZE
    mov r3, r2
    ldr r4, =COLOR_BALL
    bl draw_rect
    
    pop {r0-r5, pc}

/* Draw filled rectangle */
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
    
    /* Calculate pixel address */
    push {r0-r4}
    mov r0, r7                  /* X */
    mov r1, r5                  /* Y */
    bl get_pixel_address
    strh r4, [r0]               /* Write color */
    pop {r0-r4}
    
    add r7, r7, #1
    b draw_rect_x_loop
    
draw_rect_next_y:
    add r5, r5, #1
    b draw_rect_y_loop
    
draw_rect_done:
    pop {r0-r8, pc}

/* Get pixel address */
/* r0 = x, r1 = y */
/* Returns address in r0 */
get_pixel_address:
    push {r1-r3, lr}
    
    ldr r2, =SCREEN_WIDTH
    mul r3, r1, r2              /* y * width */
    add r3, r3, r0              /* + x */
    lsl r3, r3, #1              /* * 2 (16-bit pixels) */
    ldr r0, =FRAMEBUFFER
    add r0, r0, r3
    
    pop {r1-r3, pc}

/* Simple delay */
delay:
    push {r0, lr}
    ldr r0, =100000
delay_loop:
    subs r0, r0, #1
    bne delay_loop
    pop {r0, pc}