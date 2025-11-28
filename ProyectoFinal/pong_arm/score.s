/* score.s - Scoring system module */

.global score_init
.global score_player1
.global score_player2
.global get_score_p1
.global get_score_p2
.global draw_scores

/* Screen dimensions */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480

/* Colors */
.equ COLOR_WHITE, 0xFFFF

/* Digit dimensions for score display */
.equ DIGIT_WIDTH, 30
.equ DIGIT_HEIGHT, 50
.equ DIGIT_THICKNESS, 5

.section .data
    .align 4
player1_score: .word 0
player2_score: .word 0

.section .text

/* Initialize scores */
score_init:
    sub sp, sp, #12
    str r0, [sp, #0]
    str r1, [sp, #4]
    str lr, [sp, #8]
    
    ldr r0, =player1_score
    mov r1, #0
    str r1, [r0]
    
    ldr r0, =player2_score
    mov r1, #0
    str r1, [r0]
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr lr, [sp, #8]
    add sp, sp, #12
    mov pc, lr

/* Add point to player 1 */
score_player1:
    sub sp, sp, #12
    str r0, [sp, #0]
    str r1, [sp, #4]
    str lr, [sp, #8]
    
    ldr r0, =player1_score
    ldr r1, [r0]
    add r1, r1, #1
    str r1, [r0]
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr lr, [sp, #8]
    add sp, sp, #12
    mov pc, lr

/* Add point to player 2 */
score_player2:
    sub sp, sp, #12
    str r0, [sp, #0]
    str r1, [sp, #4]
    str lr, [sp, #8]
    
    ldr r0, =player2_score
    ldr r1, [r0]
    add r1, r1, #1
    str r1, [r0]
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr lr, [sp, #8]
    add sp, sp, #12
    mov pc, lr

/* Get player 1 score */
/* Returns score in r0 */
get_score_p1:
    ldr r0, =player1_score
    ldr r0, [r0]
    mov pc, lr

/* Get player 2 score */
/* Returns score in r0 */
get_score_p2:
    ldr r0, =player2_score
    ldr r0, [r0]
    mov pc, lr

/* Draw both scores on screen */
draw_scores:
    sub sp, sp, #24
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    str lr, [sp, #20]
    
    /* Draw player 1 score (left side) */
    bl get_score_p1
    mov r1, r0              /* Score value */
    mov r0, #200            /* X position */
    mov r2, #50             /* Y position */
    bl draw_digit
    
    /* Draw player 2 score (right side) */
    bl get_score_p2
    mov r1, r0              /* Score value */
    ldr r0, =(SCREEN_WIDTH - 200 - DIGIT_WIDTH)  /* X position */
    mov r2, #50             /* Y position */
    bl draw_digit
    
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    ldr lr, [sp, #20]
    add sp, sp, #24
    mov pc, lr

/* Draw a single digit (0-9) */
/* r0 = x position, r1 = digit value, r2 = y position */
draw_digit:
    sub sp, sp, #24
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    str lr, [sp, #20]
    
    /* Limit to single digit (0-9) */
    cmp r1, #9
    movgt r1, #9
    
    /* Draw digit based on 7-segment style */
    cmp r1, #0
    beq draw_0
    cmp r1, #1
    beq draw_1
    cmp r1, #2
    beq draw_2
    cmp r1, #3
    beq draw_3
    cmp r1, #4
    beq draw_4
    cmp r1, #5
    beq draw_5
    cmp r1, #6
    beq draw_6
    cmp r1, #7
    beq draw_7
    cmp r1, #8
    beq draw_8
    cmp r1, #9
    beq draw_9
    b digit_done

/* Each digit draws horizontal and vertical bars */
/* Using a simplified 7-segment display representation */

draw_0:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #DIGIT_HEIGHT - DIGIT_THICKNESS
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    b digit_done

draw_1:
    /* Right vertical bar only */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =DIGIT_HEIGHT
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_2:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Middle horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2) - (DIGIT_THICKNESS / 2)
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #DIGIT_HEIGHT - DIGIT_THICKNESS
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_3:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Middle horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2) - (DIGIT_THICKNESS / 2)
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #DIGIT_HEIGHT - DIGIT_THICKNESS
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_4:
    /* Top left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =DIGIT_HEIGHT
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Middle horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2) - (DIGIT_THICKNESS / 2)
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_5:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Middle horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2) - (DIGIT_THICKNESS / 2)
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #DIGIT_HEIGHT - DIGIT_THICKNESS
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_6:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Middle horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2) - (DIGIT_THICKNESS / 2)
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #DIGIT_HEIGHT - DIGIT_THICKNESS
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_7:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Right vertical bar */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =DIGIT_HEIGHT
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_8:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Middle horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2) - (DIGIT_THICKNESS / 2)
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2)
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #DIGIT_HEIGHT - DIGIT_THICKNESS
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

draw_9:
    /* Top horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top left vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =(DIGIT_HEIGHT / 2)
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Top right vertical */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    add r0, r0, #DIGIT_WIDTH - DIGIT_THICKNESS
    mov r1, r2
    ldr r2, =DIGIT_THICKNESS
    ldr r3, =DIGIT_HEIGHT
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Middle horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #(DIGIT_HEIGHT / 2) - (DIGIT_THICKNESS / 2)
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    
    /* Bottom horizontal */
    sub sp, sp, #20
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    mov r1, r2
    add r1, r1, #DIGIT_HEIGHT - DIGIT_THICKNESS
    ldr r2, =DIGIT_WIDTH
    ldr r3, =DIGIT_THICKNESS
    ldr r4, =COLOR_WHITE
    bl draw_rect
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    add sp, sp, #20
    b digit_done

digit_done:
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r2, [sp, #8]
    ldr r3, [sp, #12]
    ldr r4, [sp, #16]
    ldr lr, [sp, #20]
    add sp, sp, #24
    mov pc, lr