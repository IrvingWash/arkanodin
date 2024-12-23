package arkanodin

import rl "vendor:raylib"

GAME_TITLE :: "Arkanodin"

// Window
WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600
TARGET_FPS :: 60
CLEAR_COLOR :: rl.BLACK

// Bricks
BRICK_COLUMNS_COUNT :: 10
BRICK_ROWS_COUNT :: 8
BRICK_COUNT :: BRICK_COLUMNS_COUNT * BRICK_ROWS_COUNT
BRICK_WIDTH :: WINDOW_WIDTH / BRICK_COLUMNS_COUNT
BRICK_HEIGHT :: 20
BRICK_COLOR :: rl.BLUE
BRICK_OUTLINE :: rl.WHITE

// Ball
BALL_WIDTH :: 20
BALL_HEIGHT :: 20
BALL_COLOR :: rl.WHITE
BALL_OUTLINE :: rl.BLUE
BALL_SPEED :: 50

// Paddle
PADDLE_WIDTH :: 70
PADDLE_HEIGHT :: 20
PADDLE_COLOR :: rl.RED
PADDLE_OUTLINE :: rl.WHITE
PADDLE_SPEED :: 50
PADDLE_BOTTOM_OFFSET :: 100

// Score
MAX_SCORE :: 10_000
POINTS_PER_BRICK :: MAX_SCORE / BRICK_COUNT
SCORE_BOTTOM_OFFSET :: WINDOW_HEIGHT - 50
SCORE_LEFT_OFFSET :: 100
SCORE_FONT_SIZE :: 16
SCORE_COLOR :: rl.WHITE

// Win screen
WIN_SCREEN_TEXT :: "You won!"
WIN_SCREEN_X_POSITION :: WINDOW_WIDTH / 2 - 100 // Lazy way to approximately center the text horizontally
WIN_SCREEN_Y_POSITION :: WINDOW_HEIGHT / 2
WIN_SCREEN_FONT_SIZE :: 36
WIN_WIN_SCREEN_FONT_COLOR :: rl.GREEN

// Game over screen
GAME_OVER_SCREEN_TEXT :: "Game over"
GAME_OVER_SCREEN_X_POSITION :: WINDOW_WIDTH / 2 - 100 // Lazy way to approximately center the text horizontally
GAME_OVER_SCREEN_Y_POSITION :: WINDOW_HEIGHT / 2
GAME_OVER_SCREEN_FONT_SIZE :: 36
GAME_OVER_SCREEN_FONT_COLOR :: rl.RED
