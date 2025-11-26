/* ball.s - Ball physics module */

.global ball_init
.global ball_update
.global ball_draw
.global ball_reset
.global ball_check_score
.global ball_get_pos
.global ball_bounce_horizontal

/* Screen dimensions */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480

/* Ball constants */
.equ BALL_SIZE, 8
.equ BALL_SPEED_X, 2        /* Slower horizontal speed */
.equ BALL_SPEED_Y, 2        /* Slower vertical speed */

/* Colors */
.equ COLOR_BALL, 0xF800      /* Red */

.section .data
    .align 4
ball_x: .word 320            /* Ball X position (center) */
ball_y: .word 240            /* Ball Y position (center) */
ball_dx: .word 2             /* Ball X velocity */
ball_dy: .word 1             /* Ball Y velocity */

.section .text

/* Initialize ball to center */
ball_init:
    push {r0-r2, lr}
    
    ldr r0, =ball_x
    ldr r1, =(SCREEN_WIDTH / 2)
    str r1, [r0]
    
    ldr r0, =ball_y
    ldr r1, =(SCREEN_HEIGHT / 2)
    str r1, [r0]
    
    ldr r0, =ball_dx
    ldr r1, =BALL_SPEED_X
    str r1, [r0]
    
    ldr r0, =ball_dy
    ldr r1, =BALL_SPEED_Y
    str r1, [r0]
    
    pop {r0-r2, pc}

/* Reset ball to center (after scoring) */
ball_reset:
    push {r0-r2, lr}
    
    ldr r0, =ball_x
    ldr r1, =(SCREEN_WIDTH / 2)
    str r1, [r0]
    
    ldr r0, =ball_y
    ldr r1, =(SCREEN_HEIGHT / 2)
    str r1, [r0]
    
    /* Reverse X direction so it goes toward the other player */
    ldr r0, =ball_dx
    ldr r1, [r0]
    rsb r1, r1, #0
    str r1, [r0]
    
    pop {r0-r2, pc}

/* Update ball position */
ball_update:
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
    
    /* Check top/bottom wall collisions */
    bl ball_check_walls
    
    pop {r0-r3, pc}

/* Check wall collisions (top and bottom) */
ball_check_walls:
    push {r0-r2, lr}
    
    ldr r0, =ball_y
    ldr r1, [r0]
    
    /* Check top wall */
    cmp r1, #0
    ble bounce_vertical
    
    /* Check bottom wall */
    ldr r2, =(SCREEN_HEIGHT - BALL_SIZE)
    cmp r1, r2
    bge bounce_vertical
    
    b walls_done
    
bounce_vertical:
    /* Reverse Y velocity */
    ldr r0, =ball_dy
    ldr r1, [r0]
    rsb r1, r1, #0
    str r1, [r0]
    
walls_done:
    pop {r0-r2, pc}

/* Check if ball scored (went past paddles) */
/* Returns: r0 = 0 (no score), 1 (player 1 scored), 2 (player 2 scored) */
ball_check_score:
    push {r1-r2, lr}
    
    ldr r0, =ball_x
    ldr r1, [r0]
    
    /* Check if ball went past left edge (player 2 scores) */
    cmp r1, #0
    ble player2_scored
    
    /* Check if ball went past right edge (player 1 scores) */
    ldr r2, =SCREEN_WIDTH
    cmp r1, r2
    bge player1_scored
    
    /* No score */
    mov r0, #0
    b score_check_done
    
player1_scored:
    mov r0, #1
    b score_check_done
    
player2_scored:
    mov r0, #2
    
score_check_done:
    pop {r1-r2, pc}

/* Draw ball */
ball_draw:
    push {r0-r4, lr}
    
    ldr r0, =ball_x
    ldr r0, [r0]
    ldr r1, =ball_y
    ldr r1, [r1]
    ldr r2, =BALL_SIZE
    mov r3, r2
    ldr r4, =COLOR_BALL
    bl draw_rect
    
    pop {r0-r4, pc}

/* Get ball position */
/* Returns: r0 = x, r1 = y */
ball_get_pos:
    push {r2, lr}
    
    ldr r2, =ball_x
    ldr r0, [r2]
    ldr r2, =ball_y
    ldr r1, [r2]
    
    pop {r2, pc}

/* Get ball velocity */
/* Returns: r0 = dx, r1 = dy */
ball_get_velocity:
    push {r2, lr}
    
    ldr r2, =ball_dx
    ldr r0, [r2]
    ldr r2, =ball_dy
    ldr r1, [r2]
    
    pop {r2, pc}

/* Bounce ball horizontally (for paddle collision) */
ball_bounce_horizontal:
    push {r0-r1, lr}
    
    ldr r0, =ball_dx
    ldr r1, [r0]
    rsb r1, r1, #0
    str r1, [r0]
    
    pop {r0-r1, pc}
