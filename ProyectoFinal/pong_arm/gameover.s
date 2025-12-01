/* gameover.s - Game over and win condition module (ARMv4 Compatible) */

.global check_winner
.global draw_win_message
.global draw_char
.global draw_string
.extern get_score_p1
.extern get_score_p2
.extern draw_rect

/* Game constants */
.equ WINNING_SCORE, 5

/* Screen dimensions */
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480

/* Colors */
.equ COLOR_WHITE, 0xFFFF
.equ COLOR_YELLOW, 0xFFE0

/* Character dimensions (simple 5x7 font) */
.equ CHAR_WIDTH, 5
.equ CHAR_HEIGHT, 7
.equ CHAR_SCALE, 6          /* Scale up characters for better visibility */

.section .text

/* Check if there's a winner */
/* Returns: r0 = 0 (no winner), 1 (player 1), 2 (player 2) */
check_winner:
    /* Save registers using STMFD (store multiple full descending) */
    stmfd sp!, {r1-r2, lr}
    
    /* Check player 1 score */
    bl get_score_p1
    cmp r0, #WINNING_SCORE
    bge player1_wins
    
    /* Check player 2 score */
    bl get_score_p2
    cmp r0, #WINNING_SCORE
    bge player2_wins
    
    /* No winner yet */
    mov r0, #0
    b check_done
    
player1_wins:
    mov r0, #1
    b check_done
    
player2_wins:
    mov r0, #2
    
check_done:
    /* Restore registers using LDMFD (load multiple full descending) */
    ldmfd sp!, {r1-r2, pc}

/* Draw win message for specified player */
/* r0 = player number (1 or 2) */
draw_win_message:
    stmfd sp!, {r0-r4, lr}
    
    mov r4, r0                  /* Save player number */
    
    /* Draw "PLAYER" */
    mov r0, #140                /* X position (centered) */
    mov r1, #160                /* Y position */
    ldr r2, =msg_player
    bl draw_string
    
    /* Draw player number (space already in string) */
    mov r0, #380                /* X position for number */
    mov r1, #160
    add r2, r4, #'0'            /* Convert to ASCII */
    bl draw_large_char
    
    /* Draw "WINS!" on next line */
    mov r0, #180                /* X position */
    mov r1, #220                /* Y position */
    ldr r2, =msg_wins
    bl draw_string
    
    ldmfd sp!, {r0-r4, pc}

/* Draw a string */
/* r0 = x, r1 = y, r2 = string address */
draw_string:
    stmfd sp!, {r0-r5, lr}
    
    mov r3, r0                  /* Current X position */
    mov r4, r1                  /* Y position */
    mov r5, r2                  /* String pointer */
    
draw_string_loop:
    ldrb r2, [r5], #1           /* Load character with post-increment */
    cmp r2, #0                  /* Check for null terminator */
    beq draw_string_done
    
    /* Draw character */
    mov r0, r3
    mov r1, r4
    bl draw_large_char
    
    /* Move to next character position */
    mov r6, #CHAR_WIDTH
    mov r7, #CHAR_SCALE
    mul r6, r7, r6              /* CHAR_WIDTH * CHAR_SCALE */
    add r6, r6, #8              /* Add spacing */
    add r3, r3, r6              /* Update X position */
    b draw_string_loop
    
draw_string_done:
    ldmfd sp!, {r0-r5, pc}

/* Draw a large character (scaled up) */
/* r0 = x, r1 = y, r2 = ASCII character */
draw_large_char:
    stmfd sp!, {r0-r8, lr}
    
    /* Only support uppercase letters and space */
    cmp r2, #' '
    beq char_space
    cmp r2, #'0'
    blt char_done
    cmp r2, #'9'
    ble char_digit
    cmp r2, #'A'
    blt char_done
    cmp r2, #'Z'
    bgt char_done
    
    /* Get character bitmap */
    sub r2, r2, #'A'            /* Convert to index */
    ldr r3, =font_data
    mov r4, #7                  /* 7 rows per character */
    mul r5, r2, r4
    add r3, r3, r5              /* Pointer to character data */
    
    b draw_char_bitmap

char_digit:
    sub r2, r2, #'0'
    add r2, r2, #26             /* Digits come after letters */
    ldr r3, =font_data
    mov r4, #7
    mul r5, r2, r4
    add r3, r3, r5
    b draw_char_bitmap
    
char_space:
    /* Just skip, don't draw anything */
    b char_done

draw_char_bitmap:
    mov r6, #0                  /* Row counter */
    
char_row_loop:
    cmp r6, #CHAR_HEIGHT
    bge char_done
    
    ldrb r7, [r3, r6]           /* Load row bitmap */
    mov r8, #0                  /* Column counter */
    
char_col_loop:
    cmp r8, #CHAR_WIDTH
    bge char_next_row
    
    /* Check if pixel is set (check from right to left) */
    mov r4, #CHAR_WIDTH
    sub r4, r4, #1
    sub r4, r4, r8              /* Reverse column index */
    mov r5, #1
    mov r5, r5, lsl r4          /* Shift left by r4 */
    tst r7, r5
    beq char_skip_pixel
    
    /* Draw scaled pixel */
    stmfd sp!, {r0-r4}
    
    mov r4, #CHAR_SCALE
    mul r2, r8, r4              /* X offset */
    add r0, r0, r2
    mov r4, #CHAR_SCALE
    mul r2, r6, r4              /* Y offset */
    add r1, r1, r2
    mov r2, #CHAR_SCALE         /* Width */
    mov r3, #CHAR_SCALE         /* Height */
    ldr r4, =COLOR_YELLOW
    bl draw_rect
    
    ldmfd sp!, {r0-r4}
    
char_skip_pixel:
    add r8, r8, #1
    b char_col_loop
    
char_next_row:
    add r6, r6, #1
    b char_row_loop
    
char_done:
    ldmfd sp!, {r0-r8, pc}

/* Simple 5x7 bitmap font data */
/* Each character is 7 bytes (7 rows), 5 bits per row */
.section .rodata
font_data:
    /* A */ .byte 0x0E, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11
    /* B */ .byte 0x1E, 0x11, 0x11, 0x1E, 0x11, 0x11, 0x1E
    /* C */ .byte 0x0E, 0x11, 0x10, 0x10, 0x10, 0x11, 0x0E
    /* D */ .byte 0x1E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x1E
    /* E */ .byte 0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x1F
    /* F */ .byte 0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x10
    /* G */ .byte 0x0E, 0x11, 0x10, 0x17, 0x11, 0x11, 0x0F
    /* H */ .byte 0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11
    /* I */ .byte 0x0E, 0x04, 0x04, 0x04, 0x04, 0x04, 0x0E
    /* J */ .byte 0x01, 0x01, 0x01, 0x01, 0x11, 0x11, 0x0E
    /* K */ .byte 0x11, 0x12, 0x14, 0x18, 0x14, 0x12, 0x11
    /* L */ .byte 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1F
    /* M */ .byte 0x11, 0x1B, 0x15, 0x15, 0x11, 0x11, 0x11
    /* N */ .byte 0x11, 0x19, 0x15, 0x13, 0x11, 0x11, 0x11
    /* O */ .byte 0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E
    /* P */ .byte 0x1E, 0x11, 0x11, 0x1E, 0x10, 0x10, 0x10
    /* Q */ .byte 0x0E, 0x11, 0x11, 0x11, 0x15, 0x12, 0x0D
    /* R */ .byte 0x1E, 0x11, 0x11, 0x1E, 0x14, 0x12, 0x11
    /* S */ .byte 0x0E, 0x11, 0x10, 0x0E, 0x01, 0x11, 0x0E
    /* T */ .byte 0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04
    /* U */ .byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E
    /* V */ .byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x0A, 0x04
    /* W */ .byte 0x11, 0x11, 0x11, 0x15, 0x15, 0x1B, 0x11
    /* X */ .byte 0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11
    /* Y */ .byte 0x11, 0x11, 0x0A, 0x04, 0x04, 0x04, 0x04
    /* Z */ .byte 0x1F, 0x01, 0x02, 0x04, 0x08, 0x10, 0x1F
    /* 0 */ .byte 0x0E, 0x11, 0x13, 0x15, 0x19, 0x11, 0x0E
    /* 1 */ .byte 0x04, 0x0C, 0x04, 0x04, 0x04, 0x04, 0x0E
    /* 2 */ .byte 0x0E, 0x11, 0x01, 0x0E, 0x10, 0x10, 0x1F
    /* 3 */ .byte 0x0E, 0x11, 0x01, 0x0E, 0x01, 0x11, 0x0E
    /* 4 */ .byte 0x11, 0x11, 0x11, 0x1F, 0x01, 0x01, 0x01
    /* 5 */ .byte 0x1F, 0x10, 0x1E, 0x01, 0x01, 0x11, 0x0E
    /* 6 */ .byte 0x0E, 0x10, 0x10, 0x1E, 0x11, 0x11, 0x0E
    /* 7 */ .byte 0x1F, 0x01, 0x02, 0x04, 0x08, 0x08, 0x08
    /* 8 */ .byte 0x0E, 0x11, 0x11, 0x0E, 0x11, 0x11, 0x0E
    /* 9 */ .byte 0x0E, 0x11, 0x11, 0x0F, 0x01, 0x11, 0x0E

msg_player: .asciz "PLAYER "
msg_wins:   .asciz "WINS!"