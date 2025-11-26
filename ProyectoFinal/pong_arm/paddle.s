/* paddle.s - Paddle control module */

.global paddle_init
.global paddle_update
.global paddle_draw
.global paddle_check_collision

/* Screen dimensions */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480

/* Paddle constants */
.equ PADDLE_WIDTH, 10
.equ PADDLE_HEIGHT, 60
.equ PADDLE_SPEED, 4
.equ PADDLE1_X, 20
.equ PADDLE2_X, 610          /* SCREEN_WIDTH - 20 - PADDLE_WIDTH */

/* Ball constants (for collision) */
.equ BALL_SIZE, 8

/* Colors */
.equ COLOR_PADDLE, 0x07E0    /* Green */

/* UART for input */
.equ UART0_BASE, 0x101f1000
.equ UART_DR, 0x00
.equ UART_FR, 0x18
.equ UART_FR_RXFE, 0x10

.section .data
    .align 4
paddle1_y: .word 210         /* Left paddle Y position */
paddle2_y: .word 210         /* Right paddle Y position */

.section .text

/* Initialize paddles */
paddle_init:
    push {r0-r2, lr}
    
    ldr r0, =paddle1_y
    ldr r1, =(SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2)
    str r1, [r0]
    
    ldr r0, =paddle2_y
    ldr r1, =(SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2)
    str r1, [r0]
    
    pop {r0-r2, pc}

/* Update paddles based on input */
paddle_update:
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
    /* Check for 'i' - paddle2 up */
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
    /* Check for 'k' - paddle2 down */
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

/* Draw both paddles */
paddle_draw:
    push {r0-r4, lr}
    
    /* Draw left paddle */
    ldr r0, =PADDLE1_X
    ldr r1, =paddle1_y
    ldr r1, [r1]
    ldr r2, =PADDLE_WIDTH
    ldr r3, =PADDLE_HEIGHT
    ldr r4, =COLOR_PADDLE
    bl draw_rect
    
    /* Draw right paddle */
    ldr r0, =PADDLE2_X
    ldr r1, =paddle2_y
    ldr r1, [r1]
    ldr r2, =PADDLE_WIDTH
    ldr r3, =PADDLE_HEIGHT
    ldr r4, =COLOR_PADDLE
    bl draw_rect
    
    pop {r0-r4, pc}

/* Check collision between ball and paddles */
/* Input: r0 = ball_x, r1 = ball_y */
/* Returns: r0 = 0 (no collision), 1 (left paddle), 2 (right paddle) */
paddle_check_collision:
    push {r1-r6, lr}
    
    mov r4, r0                  /* Save ball_x */
    mov r5, r1                  /* Save ball_y */
    
    /* Check left paddle collision */
    ldr r0, =PADDLE1_X
    add r0, r0, #PADDLE_WIDTH   /* Right edge of paddle */
    cmp r4, r0
    bgt check_right_paddle      /* Ball is past paddle */
    
    ldr r0, =PADDLE1_X
    cmp r4, r0
    blt check_right_paddle      /* Ball hasn't reached paddle */
    
    /* Ball is at correct X, check Y */
    ldr r0, =paddle1_y
    ldr r1, [r0]                /* Paddle top */
    cmp r5, r1
    blt check_right_paddle      /* Ball above paddle */
    
    add r1, r1, #PADDLE_HEIGHT  /* Paddle bottom */
    add r6, r5, #BALL_SIZE      /* Ball bottom */
    cmp r6, r1
    bgt check_right_paddle      /* Ball below paddle */
    
    /* Collision with left paddle */
    mov r0, #1
    b collision_done
    
check_right_paddle:
    /* Check right paddle collision */
    ldr r0, =PADDLE2_X
    cmp r4, r0
    blt no_collision            /* Ball hasn't reached paddle */
    
    ldr r0, =PADDLE2_X
    add r0, r0, #PADDLE_WIDTH
    cmp r4, r0
    bgt no_collision            /* Ball is past paddle */
    
    /* Ball is at correct X, check Y */
    ldr r0, =paddle2_y
    ldr r1, [r0]                /* Paddle top */
    cmp r5, r1
    blt no_collision            /* Ball above paddle */
    
    add r1, r1, #PADDLE_HEIGHT  /* Paddle bottom */
    add r6, r5, #BALL_SIZE      /* Ball bottom */
    cmp r6, r1
    bgt no_collision            /* Ball below paddle */
    
    /* Collision with right paddle */
    mov r0, #2
    b collision_done
    
no_collision:
    mov r0, #0
    
collision_done:
    pop {r1-r6, pc}

/* Get paddle positions */
/* Returns: r0 = paddle1_y, r1 = paddle2_y */
paddle_get_positions:
    push {r2, lr}
    
    ldr r2, =paddle1_y
    ldr r0, [r2]
    ldr r2, =paddle2_y
    ldr r1, [r2]
    
    pop {r2, pc}
    