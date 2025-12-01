/* Pong Game for Custom ARMv4 Processor */

/* Memory Map:
 * Address 0: Player 1 Paddle Y
 * Address 1: Player 2 Paddle Y
 * Address 2: Ball X
 * Address 3: Ball Y
 * Address 4: Score Player 1
 * Address 5: Score Player 2
 * Address 6: Winner (0=none, 1=P1, 2=P2)
 * Address 7: Keyboard Input (RO)
 */

/* Screen dimensions */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480

/* Paddle constants */
.equ PADDLE_HEIGHT, 60
.equ PADDLE_SPEED, 4
.equ PADDLE1_X, 20
.equ PADDLE2_X, 610

/* Ball constants */
.equ BALL_SIZE, 8
.equ BALL_SPEED, 3

/* Game constants */
.equ WINNING_SCORE, 5

/* Memory addresses (word-aligned) */
.equ ADDR_P1Y, 0
.equ ADDR_P2Y, 4
.equ ADDR_BALLX, 8
.equ ADDR_BALLY, 12
.equ ADDR_SCORE1, 16
.equ ADDR_SCORE2, 20
.equ ADDR_WINNER, 24
.equ ADDR_KEYS, 28

/* Keyboard bits */
.equ KEY_P1_UP, 0x01
.equ KEY_P1_DOWN, 0x02
.equ KEY_P2_UP, 0x04
.equ KEY_P2_DOWN, 0x08

.text
.global _start

_start:
    /* Initialize game state */
    BL init_game
    
main_loop:
    /* Check if there's a winner */
    LDR r0, =ADDR_WINNER
    LDR r1, [r0]
    CMP r1, #0
    BNE main_loop        /* If winner != 0, game over, keep looping */
    
    /* Read keyboard input */
    LDR r0, =ADDR_KEYS
    LDR r4, [r0]         /* r4 = keyboard state */
    
    /* Update Player 1 paddle */
    BL update_paddle1
    
    /* Update Player 2 paddle */
    BL update_paddle2
    
    /* Update ball position */
    BL update_ball
    
    /* Small delay for game speed */
    BL delay
    
    B main_loop

/* Initialize game state */
init_game:
    /* Set P1 paddle Y to center */
    LDR r0, =ADDR_P1Y
    MOV r1, #210         /* (480 - 60) / 2 */
    STR r1, [r0]
    
    /* Set P2 paddle Y to center */
    LDR r0, =ADDR_P2Y
    MOV r1, #210
    STR r1, [r0]
    
    /* Set ball to center */
    LDR r0, =ADDR_BALLX
    MOV r1, #316         /* 640/2 - 4 */
    STR r1, [r0]
    
    LDR r0, =ADDR_BALLY
    MOV r1, #236         /* 480/2 - 4 */
    STR r1, [r0]
    
    /* Initialize ball velocity in registers (will use r10, r11) */
    MOV r10, #3          /* ball_vx = 3 (moving right) */
    MOV r11, #2          /* ball_vy = 2 (moving down) */
    
    /* Initialize scores to 0 */
    LDR r0, =ADDR_SCORE1
    MOV r1, #0
    STR r1, [r0]
    
    LDR r0, =ADDR_SCORE2
    MOV r1, #0
    STR r1, [r0]
    
    /* Initialize winner to 0 */
    LDR r0, =ADDR_WINNER
    MOV r1, #0
    STR r1, [r0]
    
    MOV pc, lr

/* Update Player 1 paddle (uses r4 for keys) */
update_paddle1:
    LDR r0, =ADDR_P1Y
    LDR r1, [r0]         /* r1 = current P1 Y */
    
    /* Check UP key (bit 0) */
    AND r2, r4, #KEY_P1_UP
    CMP r2, #0
    BEQ check_p1_down
    
    /* Move up */
    SUB r1, r1, #PADDLE_SPEED
    CMP r1, #0
    BGE store_p1y
    MOV r1, #0           /* Clamp to 0 */
    B store_p1y
    
check_p1_down:
    /* Check DOWN key (bit 1) */
    AND r2, r4, #KEY_P1_DOWN
    CMP r2, #0
    BEQ store_p1y
    
    /* Move down */
    ADD r1, r1, #PADDLE_SPEED
    MOV r2, #420         /* 480 - 60 */
    CMP r1, r2
    BLE store_p1y
    MOV r1, r2           /* Clamp to max */
    
store_p1y:
    STR r1, [r0]
    MOV pc, lr

/* Update Player 2 paddle (uses r4 for keys) */
update_paddle2:
    LDR r0, =ADDR_P2Y
    LDR r1, [r0]         /* r1 = current P2 Y */
    
    /* Check UP key (bit 2) */
    AND r2, r4, #KEY_P2_UP
    CMP r2, #0
    BEQ check_p2_down
    
    /* Move up */
    SUB r1, r1, #PADDLE_SPEED
    CMP r1, #0
    BGE store_p2y
    MOV r1, #0           /* Clamp to 0 */
    B store_p2y
    
check_p2_down:
    /* Check DOWN key (bit 3) */
    AND r2, r4, #KEY_P2_DOWN
    CMP r2, #0
    BEQ store_p2y
    
    /* Move down */
    ADD r1, r1, #PADDLE_SPEED
    MOV r2, #420         /* 480 - 60 */
    CMP r1, r2
    BLE store_p2y
    MOV r1, r2           /* Clamp to max */
    
store_p2y:
    STR r1, [r0]
    MOV pc, lr

/* Update ball position and handle collisions */
update_ball:
    /* Load ball position */
    LDR r0, =ADDR_BALLX
    LDR r5, [r0]         /* r5 = ball_x */
    LDR r0, =ADDR_BALLY
    LDR r6, [r0]         /* r6 = ball_y */
    
    /* Update position with velocity */
    ADD r5, r5, r10      /* ball_x += ball_vx */
    ADD r6, r6, r11      /* ball_y += ball_vy */
    
    /* Check top/bottom collision */
    CMP r6, #0
    BLE bounce_top
    MOV r0, #472         /* 480 - 8 */
    CMP r6, r0
    BGE bounce_bottom
    B check_left_right
    
bounce_top:
    MOV r6, #0
    RSB r11, r11, #0     /* ball_vy = -ball_vy */
    B check_left_right
    
bounce_bottom:
    MOV r6, #472
    RSB r11, r11, #0     /* ball_vy = -ball_vy */
    
check_left_right:
    /* Check if ball went past left edge */
    CMP r5, #0
    BLT score_p2
    
    /* Check if ball went past right edge */
    MOV r0, #632         /* 640 - 8 */
    CMP r5, r0
    BGT score_p1
    
    /* Check paddle collisions */
    /* Check P1 paddle collision */
    MOV r0, #30          /* PADDLE1_X + PADDLE_WIDTH */
    CMP r5, r0
    BGT check_p2_paddle
    
    /* Ball is in P1 paddle X range, check Y */
    LDR r0, =ADDR_P1Y
    LDR r1, [r0]         /* r1 = P1 paddle top */
    CMP r6, r1
    BLT check_p2_paddle  /* Ball above paddle */
    
    ADD r2, r1, #PADDLE_HEIGHT
    CMP r6, r2
    BGT check_p2_paddle  /* Ball below paddle */
    
    /* Collision with P1 paddle */
    MOV r5, #30
    RSB r10, r10, #0     /* ball_vx = -ball_vx */
    B save_ball
    
check_p2_paddle:
    /* Check P2 paddle collision */
    MOV r0, #610         /* PADDLE2_X */
    CMP r5, r0
    BLT save_ball
    
    /* Ball is in P2 paddle X range, check Y */
    LDR r0, =ADDR_P2Y
    LDR r1, [r0]         /* r1 = P2 paddle top */
    CMP r6, r1
    BLT save_ball        /* Ball above paddle */
    
    ADD r2, r1, #PADDLE_HEIGHT
    CMP r6, r2
    BGT save_ball        /* Ball below paddle */
    
    /* Collision with P2 paddle */
    MOV r5, #610
    RSB r10, r10, #0     /* ball_vx = -ball_vx */
    
save_ball:
    /* Save updated ball position */
    LDR r0, =ADDR_BALLX
    STR r5, [r0]
    LDR r0, =ADDR_BALLY
    STR r6, [r0]
    MOV pc, lr

score_p1:
    /* Player 1 scored */
    LDR r0, =ADDR_SCORE1
    LDR r1, [r0]
    ADD r1, r1, #1
    STR r1, [r0]
    
    /* Check if won */
    CMP r1, #WINNING_SCORE
    BEQ p1_wins
    
    /* Reset ball */
    BL reset_ball
    MOV pc, lr
    
p1_wins:
    LDR r0, =ADDR_WINNER
    MOV r1, #1
    STR r1, [r0]
    MOV pc, lr

score_p2:
    /* Player 2 scored */
    LDR r0, =ADDR_SCORE2
    LDR r1, [r0]
    ADD r1, r1, #1
    STR r1, [r0]
    
    /* Check if won */
    CMP r1, #WINNING_SCORE
    BEQ p2_wins
    
    /* Reset ball */
    BL reset_ball
    MOV pc, lr
    
p2_wins:
    LDR r0, =ADDR_WINNER
    MOV r1, #2
    STR r1, [r0]
    MOV pc, lr

/* Reset ball to center after score */
reset_ball:
    LDR r0, =ADDR_BALLX
    MOV r1, #316
    STR r1, [r0]
    
    LDR r0, =ADDR_BALLY
    MOV r1, #236
    STR r1, [r0]
    
    /* Reverse ball direction */
    RSB r10, r10, #0
    
    MOV pc, lr

/* Simple delay loop */
delay:
    MOV r0, #50000       /* Delay counter */
delay_loop:
    SUB r0, r0, #1
    CMP r0, #0
    BGT delay_loop
    MOV pc, lr