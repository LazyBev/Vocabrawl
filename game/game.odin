package main

import rl "vendor:raylib"

GameState :: enum {
    MENU,
    PLAYING,
    OPTIONS,
    GAME_OVER,
}

Game :: struct {
    state: GameState,
    selected_index: int,
    background: rl.Texture2D,
    master_volume: f32,
    music_volume: f32,
    sfx_volume: f32,
}

init_game :: proc() -> Game {
    // Load background image
    background := rl.LoadTexture("assets/Backgrounds/Vocaloids.jpg")
    
    return Game{
        state = .MENU,
        selected_index = 0,
        background = background,
        master_volume = 0.8,
        music_volume = 0.7,
        sfx_volume = 0.8,
    }
}