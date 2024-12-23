package arkanodin

import rl "vendor:raylib"

create_window :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, GAME_TITLE)

	rl.SetTargetFPS(TARGET_FPS)
}

close_window :: proc() {
	rl.CloseWindow()
}

Vector2 :: struct {
	x: f64,
	y: f64,
}

add_vector2s_in_place :: proc(lhs: ^Vector2, rhs: Vector2) {
	lhs.x += rhs.x
	lhs.y += rhs.y
}
