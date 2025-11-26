/* pong_main.s - Main game loop */

.global pong_main

/* External functions from other modules */
.extern lcd_init
.extern clear_buffer
.extern swap_buffers
.extern score_init
.extern score_player1
.extern score_player2
.extern draw_scores
.extern ball_init
.extern ball_update
.extern ball_draw
.extern ball_reset
.extern ball_check_score
.extern ball_get_pos
.extern ball_bounce_horizontal
.extern paddle_init
.extern paddle_update
.extern paddle_draw
.extern paddle_check_collision
.extern check_winner
.extern draw_win_message

.section .text

/* Main game entry point */
pong_main:
    push {r4-r11, lr}
    
    /* Initialize all game systems */
    bl score_init
    bl ball_init
    bl paddle_init
    
    /* Clear initial screen */
    bl clear_buffer
    bl swap_buffers
    
/* Main game loop */
game_loop:
    /* Handle input */
    bl paddle_update
    
    /* Update ball position */
    bl ball_update
    
    /* Get ball position for collision checks */
    bl ball_get_pos
    mov r4, r0                  /* Save ball_x */
    mov r5, r1                  /* Save ball_y */
    
    /* Check paddle collisions */
    mov r0, r4
    mov r1, r5
    bl paddle_check_collision
    cmp r0, #0
    beq no_paddle_collision
    
    /* Ball hit a paddle, bounce it */
    bl ball_bounce_horizontal
    
no_paddle_collision:
    /* Check if someone scored */
    bl ball_check_score
    cmp r0, #0
    beq no_score
    
    /* Someone scored! */
    cmp r0, #1
    beq player1_point
    cmp r0, #2
    beq player2_point
    
player1_point:
    bl score_player1
    bl ball_reset
    bl delay_long              /* Longer delay after scoring */
    b no_score
    
player2_point:
    bl score_player2
    bl ball_reset
    bl delay_long              /* Longer delay after scoring */
    
no_score:
    /* Check for winner */
    bl check_winner
    cmp r0, #0
    bne game_over
    
    /* Clear back buffer */
    bl clear_buffer
    
    /* Draw center line */
    bl draw_center_line
    
    /* Draw all game objects */
    bl paddle_draw
    bl ball_draw
    bl draw_scores
    
    /* Swap buffers to display */
    bl swap_buffers
    
    /* Delay for frame rate control */
    bl delay
    
    /* Loop forever */
    b game_loop

/* Game over - someone won! */
game_over:
    mov r4, r0                  /* Save winner number */
    
    /* Clear screen */
    bl clear_buffer
    
    /* Draw final scores */
    bl draw_scores
    
    /* Draw center line */
    bl draw_center_line
    
    /* Draw win message */
    mov r0, r4
    bl draw_win_message
    
    /* Swap buffers */
    bl swap_buffers
    
    /* Halt (game over) */
game_over_loop:
    b game_over_loop
    
    pop {r4-r11, pc}

/* Draw center line (dashed) */
draw_center_line:
    push {r0-r4, lr}
    
    mov r5, #0                  /* Y position */
    ldr r6, =SCREEN_HEIGHT
    
center_line_loop:
    cmp r5, r6
    bge center_line_done
    
    /* Draw a small segment */
    ldr r0, =CENTER_X                /* X position (center) */
    mov r1, r5                       /* Y position */
    mov r2, #4                       /* Width */
    mov r3, #10                      /* Height (dash length) */
    ldr r4, =0xFFFF                  /* White color */
    bl draw_rect
    
    add r5, r5, #20             /* Move down (dash + gap) */
    b center_line_loop
    
center_line_done:
    pop {r0-r4, pc}

/* Frame rate delay (controls game speed) */
delay:
    push {r0, lr}
    ldr r0, =200000             /* Adjust this for game speed */
delay_loop:
    subs r0, r0, #1
    bne delay_loop
    pop {r0, pc}

/* Longer delay after scoring */
delay_long:
    push {r0, lr}
    ldr r0, =500000
delay_long_loop:
    subs r0, r0, #1
    bne delay_long_loop
    pop {r0, pc}

/* Constants */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480
.equ CENTER_X, 318  /* (640 / 2) - 2 */
