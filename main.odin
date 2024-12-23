package arkanodin

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

GameState :: enum {
	Start,
	Play,
	Win,
	GameOver,
}

main :: proc() {
	create_window()
	defer close_window()

	bricks: [BRICK_COUNT]Brick = ---
	ball: Ball = ---
	paddle: Paddle = ---
	score: Score = ---
	game_state: GameState = ---

	init_game_objects(&game_state, &ball, &paddle, &bricks, &score)

	for !rl.WindowShouldClose() {
		update(&ball, &paddle, &bricks, &score, &game_state)

		render(bricks, paddle, ball, score, game_state)
	}
}

update :: proc(
	ball: ^Ball,
	paddle: ^Paddle,
	bricks: ^[BRICK_COUNT]Brick,
	score: ^Score,
	game_state: ^GameState,
) {
	dt := f64(rl.GetFrameTime() * 10)

	restart(game_state, ball, paddle, bricks, score)

	if game_state^ == GameState.Start {
		if launch_ball(ball) {
			game_state^ = GameState.Play
		}
	} else if game_state^ == GameState.Play {
		move_ball(ball, dt)
		collide_ball_with_paddle(ball, paddle^)
		collide_ball_with_walls(ball, game_state)
		collide_ball_with_bricks(ball, bricks)
		update_score(score, bricks, game_state)
	}

	if game_state^ != GameState.Win && game_state^ != GameState.GameOver {
		collide_paddle_with_walls(paddle)
		move_paddle(paddle, ball, game_state^, dt)
	}
}

render :: proc(
	bricks: [BRICK_COUNT]Brick,
	paddle: Paddle,
	ball: Ball,
	score: Score,
	game_state: GameState,
) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(CLEAR_COLOR)

	for brick in bricks {
		draw_brick(brick)
	}

	draw_paddle(paddle)
	draw_ball(ball)
	draw_score(score)

	if game_state == GameState.Win {
		rl.DrawText(
			WIN_SCREEN_TEXT,
			WIN_SCREEN_X_POSITION,
			WIN_SCREEN_Y_POSITION,
			WIN_SCREEN_FONT_SIZE,
			WIN_WIN_SCREEN_FONT_COLOR,
		)
	}

	if game_state == GameState.GameOver {
		rl.DrawText(
			GAME_OVER_SCREEN_TEXT,
			GAME_OVER_SCREEN_X_POSITION,
			GAME_OVER_SCREEN_Y_POSITION,
			GAME_OVER_SCREEN_FONT_SIZE,
			GAME_OVER_SCREEN_FONT_COLOR,
		)
	}
}

restart :: proc(
	game_state: ^GameState,
	ball: ^Ball,
	paddle: ^Paddle,
	bricks: ^[BRICK_COUNT]Brick,
	score: ^Score,
) {
	if rl.IsKeyPressed(rl.KeyboardKey.R) {
		init_game_objects(game_state, ball, paddle, bricks, score)
	}
}

init_game_objects :: proc(
	game_state: ^GameState,
	ball: ^Ball,
	paddle: ^Paddle,
	bricks: ^[BRICK_COUNT]Brick,
	score: ^Score,
) {
	bricks^ = init_bricks()
	ball^ = init_ball()
	paddle^ = init_paddle()
	score^ = Score{}
	game_state^ = GameState.Start
}

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

draw_score :: proc(score: Score) {
	using fmt
	using strings

	rl.DrawText(
		clone_to_cstring(aprint("Score: ", score.value)),
		SCORE_LEFT_OFFSET,
		SCORE_BOTTOM_OFFSET,
		SCORE_FONT_SIZE,
		SCORE_COLOR,
	)
}
