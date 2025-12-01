#!/usr/bin/env python3
"""
Pong Game Simulator - Models the exact hardware behavior
Tests game logic before ARM assembly implementation
"""

import os
import sys
import time
import termios
import tty
import select

# Screen dimensions
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480

# Paddle constants
PADDLE_HEIGHT = 60
PADDLE_SPEED = 4
PADDLE1_X = 20
PADDLE2_X = 610

# Ball constants
BALL_SIZE = 8
BALL_SPEED = 3

# Game constants
WINNING_SCORE = 5

# Memory simulation (8 words, 32-bit each)
ram = [0] * 8

# Memory addresses (indices)
ADDR_P1Y = 0
ADDR_P2Y = 1
ADDR_BALLX = 2
ADDR_BALLY = 3
ADDR_SCORE1 = 4
ADDR_SCORE2 = 5
ADDR_WINNER = 6
ADDR_KEYS = 7

# Keyboard state (simulated)
keys = {
    'r': False,  # P1 UP
    'f': False,  # P1 DOWN
    'o': False,  # P2 UP
    'l': False   # P2 DOWN
}

# Ball velocity (stored in registers in ARM)
ball_vx = 3
ball_vy = 2


def init_game():
    """Initialize game state - mirrors ARM init_game"""
    global ball_vx, ball_vy
    
    # Set paddles to center
    ram[ADDR_P1Y] = 210  # (480 - 60) / 2
    ram[ADDR_P2Y] = 210
    
    # Set ball to center
    ram[ADDR_BALLX] = 316  # 640/2 - 4
    ram[ADDR_BALLY] = 236  # 480/2 - 4
    
    # Initialize ball velocity
    ball_vx = 3
    ball_vy = 2
    
    # Initialize scores
    ram[ADDR_SCORE1] = 0
    ram[ADDR_SCORE2] = 0
    
    # Initialize winner
    ram[ADDR_WINNER] = 0


def update_paddle1():
    """Update Player 1 paddle - mirrors ARM update_paddle1"""
    y = ram[ADDR_P1Y]
    
    # Check UP key
    if keys['r']:
        y -= PADDLE_SPEED
        if y < 0:
            y = 0
    
    # Check DOWN key
    elif keys['f']:
        y += PADDLE_SPEED
        max_y = SCREEN_HEIGHT - PADDLE_HEIGHT
        if y > max_y:
            y = max_y
    
    ram[ADDR_P1Y] = y


def update_paddle2():
    """Update Player 2 paddle - mirrors ARM update_paddle2"""
    y = ram[ADDR_P2Y]
    
    # Check UP key
    if keys['o']:
        y -= PADDLE_SPEED
        if y < 0:
            y = 0
    
    # Check DOWN key
    elif keys['l']:
        y += PADDLE_SPEED
        max_y = SCREEN_HEIGHT - PADDLE_HEIGHT
        if y > max_y:
            y = max_y
    
    ram[ADDR_P2Y] = y


def reset_ball():
    """Reset ball to center - mirrors ARM reset_ball"""
    global ball_vx
    
    ram[ADDR_BALLX] = 316
    ram[ADDR_BALLY] = 236
    
    # Reverse ball direction
    ball_vx = -ball_vx


def update_ball():
    """Update ball position and handle collisions - mirrors ARM update_ball"""
    global ball_vx, ball_vy
    
    # Load ball position
    ball_x = ram[ADDR_BALLX]
    ball_y = ram[ADDR_BALLY]
    
    # Update position with velocity
    ball_x += ball_vx
    ball_y += ball_vy
    
    # Check top/bottom collision
    if ball_y <= 0:
        ball_y = 0
        ball_vy = -ball_vy
    elif ball_y >= SCREEN_HEIGHT - BALL_SIZE:
        ball_y = SCREEN_HEIGHT - BALL_SIZE
        ball_vy = -ball_vy
    
    # Check if ball went past left edge (P2 scores)
    if ball_x < 0:
        ram[ADDR_SCORE2] += 1
        if ram[ADDR_SCORE2] >= WINNING_SCORE:
            ram[ADDR_WINNER] = 2
        reset_ball()
        return
    
    # Check if ball went past right edge (P1 scores)
    if ball_x > SCREEN_WIDTH - BALL_SIZE:
        ram[ADDR_SCORE1] += 1
        if ram[ADDR_SCORE1] >= WINNING_SCORE:
            ram[ADDR_WINNER] = 1
        reset_ball()
        return
    
    # Check P1 paddle collision
    if ball_x <= PADDLE1_X + 10:  # PADDLE_WIDTH = 10
        p1_y = ram[ADDR_P1Y]
        if p1_y <= ball_y <= p1_y + PADDLE_HEIGHT:
            ball_x = PADDLE1_X + 10
            ball_vx = -ball_vx
    
    # Check P2 paddle collision
    if ball_x >= PADDLE2_X:
        p2_y = ram[ADDR_P2Y]
        if p2_y <= ball_y <= p2_y + PADDLE_HEIGHT:
            ball_x = PADDLE2_X
            ball_vx = -ball_vx
    
    # Save updated ball position
    ram[ADDR_BALLX] = ball_x
    ram[ADDR_BALLY] = ball_y


def render_ascii():
    """Render game state as ASCII art"""
    # Create empty field
    width = 80
    height = 24
    field = [[' ' for _ in range(width)] for _ in range(height)]
    
    # Scale coordinates
    def scale_x(x):
        return int(x * width / SCREEN_WIDTH)
    
    def scale_y(y):
        return int(y * height / SCREEN_HEIGHT)
    
    # Draw paddles
    p1_y = scale_y(ram[ADDR_P1Y])
    p2_y = scale_y(ram[ADDR_P2Y])
    paddle_h = scale_y(PADDLE_HEIGHT)
    
    for i in range(paddle_h):
        if 0 <= p1_y + i < height:
            field[p1_y + i][2] = '█'
        if 0 <= p2_y + i < height:
            field[p2_y + i][width - 3] = '█'
    
    # Draw ball
    ball_x = scale_x(ram[ADDR_BALLX])
    ball_y = scale_y(ram[ADDR_BALLY])
    if 0 <= ball_y < height and 0 <= ball_x < width:
        field[ball_y][ball_x] = '●'
    
    # Draw top/bottom borders
    for x in range(width):
        field[0][x] = '─'
        field[height - 1][x] = '─'
    
    # Clear screen and render
    os.system('clear' if os.name == 'posix' else 'cls')
    
    # Draw scores
    print(f"\n  Player 1: {ram[ADDR_SCORE1]}  {'█' * 20}  Player 2: {ram[ADDR_SCORE2]}\n")
    
    # Draw field
    for row in field:
        print(''.join(row))
    
    # Draw controls
    print("\n  P1: R(up) F(down)  |  P2: O(up) L(down)  |  Q(quit)")
    
    # Check winner
    if ram[ADDR_WINNER] == 1:
        print("\n  🎉 PLAYER 1 WINS! 🎉")
    elif ram[ADDR_WINNER] == 2:
        print("\n  🎉 PLAYER 2 WINS! 🎉")


def get_key():
    """Non-blocking keyboard input"""
    if select.select([sys.stdin], [], [], 0)[0]:
        return sys.stdin.read(1).lower()
    return None


def main():
    """Main game loop"""
    # Setup terminal for raw input
    old_settings = termios.tcgetattr(sys.stdin)
    try:
        tty.setcbreak(sys.stdin.fileno())
        
        # Initialize game
        init_game()
        
        print("Starting Pong Simulator...")
        print("First to 5 wins!")
        time.sleep(2)
        
        # Main game loop
        while True:
            # Read keyboard
            key = get_key()
            if key == 'q':
                break
            
            # Update key states
            for k in keys:
                keys[k] = (key == k)
            
            # Check if there's a winner
            if ram[ADDR_WINNER] == 0:
                # Update game state
                update_paddle1()
                update_paddle2()
                update_ball()
            
            # Render
            render_ascii()
            
            # Frame delay (~60 FPS)
            time.sleep(0.033)
    
    finally:
        # Restore terminal settings
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)
        print("\nGame ended!")


if __name__ == "__main__":
    main()