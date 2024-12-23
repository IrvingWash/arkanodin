package arkanodin

import "core:strings"
import rl "vendor:raylib"

AssetManager :: struct {
	sounds: map[string]rl.Sound,
}

am_destroy :: proc(am: ^AssetManager) {
    for _, sound in am.sounds {
        rl.UnloadSound(sound)
    }

    delete(am.sounds)
}

am_load_sound :: proc(am: ^AssetManager, name: string, path: string) {
	using strings

	sound := rl.LoadSound(clone_to_cstring(path))

	am.sounds[name] = sound
}

am_play_sound :: proc(am: AssetManager, name: string) {
	rl.PlaySound(am.sounds[name])
}
