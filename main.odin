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

	asset_manager: AssetManager
	defer am_destroy(&asset_manager)

	am_load_sound(&asset_manager, "start", "assets/start.wav") // TODO: done
	am_load_sound(&asset_manager, "break", "assets/break.wav") // TODO: done
	am_load_sound(&asset_manager, "win", "assets/win.wav") // TODO: done
	am_load_sound(&asset_manager, "game_over", "assets/game_over.wav")

	bricks: [BRICK_COUNT]Brick = ---
	ball: Ball = ---
	paddle: Paddle = ---
	score: Score = ---
	game_state: GameState = ---

	init_game_objects(&game_state, &ball, &paddle, &bricks, &score)

	for !rl.WindowShouldClose() {
		update(&ball, &paddle, &bricks, &score, &game_state, asset_manager)

		render(bricks, paddle, ball, score, game_state)
	}
}

update :: proc(
	ball: ^Ball,
	paddle: ^Paddle,
	bricks: ^[BRICK_COUNT]Brick,
	score: ^Score,
	game_state: ^GameState,
	asset_manager: AssetManager
) {
	dt := f64(rl.GetFrameTime() * 10)

	restart(game_state, ball, paddle, bricks, score)

	if game_state^ == GameState.Start {
		if launch_ball(ball, asset_manager) {
			game_state^ = GameState.Play
		}
	} else if game_state^ == GameState.Play {
		move_ball(ball, dt)
		collide_ball_with_paddle(ball, paddle^)
		collide_ball_with_walls(ball, game_state, asset_manager)
		collide_ball_with_bricks(ball, bricks, asset_manager)
		update_score(score, bricks, game_state, asset_manager)
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
