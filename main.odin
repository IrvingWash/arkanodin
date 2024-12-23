package main

import rl "vendor:raylib"

// ====================================================
// Config
// ====================================================
GAME_TITLE :: "Arkanodin"

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

// ====================================================
// Gameplay
// ====================================================
main :: proc() {
    create_window()
    defer close_window()

    bricks := init_bricks()
    ball := init_ball()
    paddle := init_paddle()

    for !rl.WindowShouldClose() {

        dt := f64(rl.GetFrameTime() * 10)

        // Update
        if !ball.has_started {
            start_ball(&ball)
        } else {
            move_ball(&ball, dt)
        }

        collide_ball_with_paddle(&ball, paddle)
        collide_ball_with_walls(&ball)
        collide_ball_with_bricks(&ball, &bricks)
        move_paddle(&paddle, &ball, dt)

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

should_start_ball :: proc() -> bool {
    return rl.IsKeyPressed(rl.KeyboardKey.SPACE)
}

start_ball :: proc(ball: ^Ball) {
    ball.has_started = should_start_ball()

    ball.velocity.x = BALL_SPEED
    ball.velocity.y = -BALL_SPEED
}

move_ball :: proc(ball: ^Ball, dt: f64) {
    ball.position.x += ball.velocity.x * dt
    ball.position.y += ball.velocity.y * dt
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

move_paddle :: proc(paddle: ^Paddle, ball: ^Ball, dt: f64) {
    paddle.velocity.x = 0
    paddle.velocity.y = 0

    if rl.IsKeyDown(rl.KeyboardKey.A) {
        paddle.velocity.x = -BALL_SPEED * dt
    }
    if rl.IsKeyDown(rl.KeyboardKey.D) {
        paddle.velocity.x = BALL_SPEED * dt
    }

    add_vector2s_in_place(&paddle.position, paddle.velocity)

    if !ball.has_started {
        ball.position.x += paddle.velocity.x
    }
}

collide_ball_with_walls :: proc(ball: ^Ball) {
    if ball.position.x < 0 || ball.position.x + BALL_WIDTH > WINDOW_WIDTH {
        ball.velocity.x *= -1
    }
    if ball.position.y < 0 || ball.position.y + BALL_HEIGHT > WINDOW_HEIGHT {
        ball.velocity.y *= -1
    }
}

collide_ball_with_paddle :: proc(ball: ^Ball, paddle: Paddle) {
    are_colliding := rl.CheckCollisionRecs(
        rl.Rectangle{
            f32(ball.position.x),
            f32(ball.position.y),
            BALL_WIDTH,
            BALL_HEIGHT
        },
        rl.Rectangle{
            f32(paddle.position.x),
            f32(paddle.position.y),
            PADDLE_WIDTH,
            PADDLE_HEIGHT,
        }
    )

    if are_colliding {
        ball.velocity.y *= -1
    }
}

collide_ball_with_bricks :: proc(ball: ^Ball, bricks: ^[BRICK_COUNT]Brick) {
    ball_rectangle := rl.Rectangle{
        f32(ball.position.x),
        f32(ball.position.y),
        BALL_WIDTH,
        BALL_HEIGHT
    }

    for &brick in bricks {
        if brick.is_broken {
            continue
        }

        are_colliding := rl.CheckCollisionRecs(
            ball_rectangle,
            rl.Rectangle{
                f32(brick.position.x),
                f32(brick.position.y),
                BRICK_WIDTH,
                BRICK_HEIGHT
            }
        )

        if are_colliding {
            brick.is_broken = true
        }
    }
}

// ====================================================
// Rendering
// ====================================================
draw_brick :: proc(brick: Brick) {
    if brick.is_broken {
        return
    }

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

// ====================================================
// Utils
// ====================================================
create_window :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})

    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, GAME_TITLE)

    rl.SetTargetFPS(TARGET_FPS)
}

close_window :: proc() {
    rl.CloseWindow()
}

Vector2 :: struct {
    x: f64,
    y: f64,
}

add_vector2s_in_place :: proc(lhs: ^Vector2, rhs: Vector2) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}
