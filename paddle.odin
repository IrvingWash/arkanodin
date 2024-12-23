package arkanodin

import rl "vendor:raylib"

Paddle :: struct {
	position:    Vector2,
	velocity:    Vector2,
	is_disabled: bool,
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

move_paddle :: proc(paddle: ^Paddle, ball: ^Ball, game_state: GameState, dt: f64) {
	paddle.velocity.x = 0
	paddle.velocity.y = 0

	if rl.IsKeyDown(rl.KeyboardKey.A) {
		paddle.velocity.x = -BALL_SPEED * dt
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) {
		paddle.velocity.x = BALL_SPEED * dt
	}

	add_vector2s_in_place(&paddle.position, paddle.velocity)

	if game_state != GameState.Play {
		ball.position.x += paddle.velocity.x
	}
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
