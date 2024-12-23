package main

import rl "vendor:raylib"

GAME_TITLE :: "Arkanodin"

// Utils
Vector2 :: struct {
    x: f64,
    y: f64,
}

add_vector2s_in_place :: proc(lhs: ^Vector2, rhs: Vector2) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

// Window
WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600
TARGET_FPS :: 60
CLEAR_COLOR :: rl.BLACK

// Bricks
BRICK_COLUMNS_COUNT :: 10
BRICK_ROWS_COUNT :: 7
BRICK_COUNT :: BRICK_COLUMNS_COUNT * BRICK_ROWS_COUNT
BRICK_WIDTH :: WINDOW_WIDTH / BRICK_COLUMNS_COUNT
BRICK_HEIGHT :: 20
BRICK_COLOR :: rl.BLUE
BRICK_OUTLINE :: rl.WHITE

Brick :: struct {
    position: Vector2,
    is_broken: bool,
}

// Ball
BALL_WIDTH :: 20
BALL_HEIGHT :: 20
BALL_COLOR :: rl.WHITE
BALL_OUTLINE :: rl.BLUE
BALL_SPEED :: 50

Ball :: struct {
    position: Vector2,
    velocity: Vector2,
    has_started: bool,
}

// Paddle
PADDLE_WIDTH :: 120
PADDLE_HEIGHT :: 20
PADDLE_COLOR :: rl.RED
PADDLE_OUTLINE :: rl.WHITE
PADDLE_SPEED :: 50
PADDLE_BOTTOM_OFFSET :: 100

Paddle :: struct {
    position: Vector2,
    velocity: Vector2,
    is_disabled: bool,
}

main :: proc() {
    create_window()
    defer close_window()

    bricks := init_bricks()
    ball := init_ball()
    paddle := init_paddle()

    for !rl.WindowShouldClose() {
        dt := f64(rl.GetFrameTime() * 10)

        // Update
        move_paddle(&paddle, dt)

        // Render
        rl.BeginDrawing()
        rl.ClearBackground(CLEAR_COLOR)

        for &brick in bricks {
            draw_brick(brick)
        }

        draw_paddle(paddle)

        draw_ball(ball)

        rl.EndDrawing()
    }
}

draw_brick :: proc(brick: Brick) {
    rl.DrawRectangle(
        i32(brick.position.x),
        i32(brick.position.y),
        BRICK_WIDTH,
        BRICK_HEIGHT,
        BRICK_COLOR,
    )

    rl.DrawRectangleLines(
        i32(brick.position.x),
        i32(brick.position.y),
        BRICK_WIDTH,
        BRICK_HEIGHT,
        BRICK_OUTLINE,
    )
}

draw_ball :: proc(ball: Ball) {
    rl.DrawRectangle(
        i32(ball.position.x),
        i32(ball.position.y),
        BALL_WIDTH,
        BALL_HEIGHT,
        BALL_COLOR,
    )

    rl.DrawRectangleLines(
        i32(ball.position.x),
        i32(ball.position.y),
        BALL_WIDTH,
        BALL_HEIGHT,
        BALL_OUTLINE,
    )
}

draw_paddle :: proc(paddle: Paddle) {
    rl.DrawRectangle(
        i32(paddle.position.x),
        i32(paddle.position.y),
        PADDLE_WIDTH,
        PADDLE_HEIGHT,
        PADDLE_COLOR,
    )

    rl.DrawRectangleLines(
        i32(paddle.position.x),
        i32(paddle.position.y),
        PADDLE_WIDTH,
        PADDLE_HEIGHT,
        PADDLE_OUTLINE,
    )
}

create_window :: proc() {
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, GAME_TITLE)
    rl.SetTargetFPS(TARGET_FPS)
}

close_window :: proc() {
    rl.CloseWindow()
}

init_ball :: proc() -> Ball {
    return Ball {
        position = Vector2{
            x = WINDOW_WIDTH / 2 - BALL_WIDTH / 2,
            y = WINDOW_HEIGHT - PADDLE_WIDTH,
        },
        velocity = Vector2{0, 0},
    }
}

init_paddle :: proc() -> Paddle {
    return Paddle {
        position = Vector2 {
            x = WINDOW_WIDTH / 2 - PADDLE_WIDTH / 2,
            y = WINDOW_HEIGHT - PADDLE_BOTTOM_OFFSET,
        },
        velocity = Vector2{0, 0},
    }
}

init_bricks :: proc() -> [BRICK_COUNT]Brick {
    result: [BRICK_COUNT]Brick

    next_index := 0
    for i in 0..<BRICK_ROWS_COUNT {
        for j in 0..<BRICK_COLUMNS_COUNT {
            result[next_index] = Brick {
                position = Vector2{
                    x = f64(j * BRICK_WIDTH),
                    y = f64(i * BRICK_HEIGHT),
                },
                is_broken = false,
            }

            next_index += 1
        }
    }

    return result
}

move_paddle :: proc(paddle: ^Paddle, dt: f64) {
    paddle.velocity.x = 0
    paddle.velocity.y = 0

    if rl.IsKeyDown(rl.KeyboardKey.A) {
        paddle.velocity.x = -BALL_SPEED * dt
    }
    if rl.IsKeyDown(rl.KeyboardKey.D) {
        paddle.velocity.x = BALL_SPEED * dt
    }

    add_vector2s_in_place(&paddle.position, paddle.velocity)
}
