package arkanodin

import rl "vendor:raylib"

Ball :: struct {
	position: Vector2,
	velocity: Vector2,
}

init_ball :: proc() -> Ball {
	return Ball {
		position = Vector2 {
			x = WINDOW_WIDTH / 2 - BALL_WIDTH / 2,
			y = WINDOW_HEIGHT - PADDLE_BOTTOM_OFFSET - PADDLE_HEIGHT,
		},
		velocity = Vector2{0, 0},
	}
}

launch_ball :: proc(ball: ^Ball, am: AssetManager) -> bool {
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
		ball.velocity.x = BALL_SPEED
		ball.velocity.y = -BALL_SPEED

		am_play_sound(am, "start")

		return true
	}

	return false
}

move_ball :: proc(ball: ^Ball, dt: f64) {
	ball.position.x += ball.velocity.x * dt
	ball.position.y += ball.velocity.y * dt
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
