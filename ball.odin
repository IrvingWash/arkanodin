package arkanodin

import rl "vendor:raylib"

Ball :: struct {
	position: Vector2,
	velocity: Vector2,
}

launch_ball :: proc(ball: ^Ball) -> bool {
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
		ball.velocity.x = BALL_SPEED
		ball.velocity.y = -BALL_SPEED

		return true
	}

	return false
}

move_ball :: proc(ball: ^Ball, dt: f64) {
	ball.position.x += ball.velocity.x * dt
	ball.position.y += ball.velocity.y * dt
}

init_ball :: proc() -> Ball {
	return Ball {
		position = Vector2 {
			x = WINDOW_WIDTH / 2 - BALL_WIDTH / 2,
			y = WINDOW_HEIGHT - PADDLE_WIDTH,
		},
		velocity = Vector2{0, 0},
	}
}
