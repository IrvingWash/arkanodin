package arkanodin

Brick :: struct {
	position:  Vector2,
	is_broken: bool,
}

init_bricks :: proc() -> [BRICK_COUNT]Brick {
	result: [BRICK_COUNT]Brick

	next_index := 0
	for i in 0 ..< BRICK_ROWS_COUNT {
		for j in 0 ..< BRICK_COLUMNS_COUNT {
			result[next_index] = Brick {
				position = Vector2{x = f64(j * BRICK_WIDTH), y = f64(i * BRICK_HEIGHT)},
				is_broken = false,
			}

			next_index += 1
		}
	}

	return result
}
