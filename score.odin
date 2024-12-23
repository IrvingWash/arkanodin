package arkanodin

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

Score :: struct {
	value: uint,
}

update_score :: proc(score: ^Score, bricks: ^[BRICK_COUNT]Brick, game_state: ^GameState, am: AssetManager) {
	broken_brick_count: uint

	for &brick in bricks {
		if brick.is_broken {
			broken_brick_count += 1
		}
	}

	score.value = broken_brick_count * POINTS_PER_BRICK

	if score.value == MAX_SCORE {
		game_state^ = GameState.Win

		am_play_sound(am, "win")
	}
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
