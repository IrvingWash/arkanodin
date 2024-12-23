package arkanodin

Score :: struct {
	value: uint,
}

update_score :: proc(score: ^Score, bricks: ^[BRICK_COUNT]Brick, game_state: ^GameState) {
	broken_brick_count: uint

	for &brick in bricks {
		if brick.is_broken {
			broken_brick_count += 1
		}
	}

	score.value = broken_brick_count * POINTS_PER_BRICK

	if score.value == MAX_SCORE {
		game_state^ = GameState.Win
	}
}
