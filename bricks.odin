package arkanodin

import rl "vendor:raylib"

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
