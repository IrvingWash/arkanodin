package arkanodin

import rl "vendor:raylib"

collide_paddle_with_walls :: proc(paddle: ^Paddle) {
	if paddle.position.x <= 0 {
		paddle.position.x = 0

		return
	}

	if paddle.position.x + PADDLE_WIDTH >= WINDOW_WIDTH {
		paddle.position.x = WINDOW_WIDTH - PADDLE_WIDTH

		return
	}
}

collide_ball_with_walls :: proc(ball: ^Ball, game_state: ^GameState) {
	if ball.position.x <= 0 || ball.position.x + BALL_WIDTH >= WINDOW_WIDTH {
		ball.velocity.x *= -1
	}
	if ball.position.y <= 0 {
		ball.velocity.y *= -1
	}
	if ball.position.y + BALL_HEIGHT >= WINDOW_HEIGHT {
		game_state^ = GameState.GameOver
	}
}

collide_ball_with_paddle :: proc(ball: ^Ball, paddle: Paddle) {
	are_colliding := rl.CheckCollisionRecs(
		rl.Rectangle{f32(ball.position.x), f32(ball.position.y), BALL_WIDTH, BALL_HEIGHT},
		rl.Rectangle{f32(paddle.position.x), f32(paddle.position.y), PADDLE_WIDTH, PADDLE_HEIGHT},
	)

	if are_colliding {
		ball.velocity.y *= -1
	}
}

collide_ball_with_bricks :: proc(ball: ^Ball, bricks: ^[BRICK_COUNT]Brick) {
	ball_rectangle := rl.Rectangle {
		f32(ball.position.x),
		f32(ball.position.y),
		BALL_WIDTH,
		BALL_HEIGHT,
	}

	for &brick in bricks {
		if brick.is_broken {
			continue
		}

		are_colliding := rl.CheckCollisionRecs(
			ball_rectangle,
			rl.Rectangle{f32(brick.position.x), f32(brick.position.y), BRICK_WIDTH, BRICK_HEIGHT},
		)

		if are_colliding {
			brick.is_broken = true
		}
	}
}
