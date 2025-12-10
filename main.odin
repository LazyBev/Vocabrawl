package main

import rl "vendor:raylib"

main :: proc() {
    screen_width :: 1000
    screen_height :: 800
    
    rl.InitWindow(screen_width, screen_height, "YOMI Hustle Style Fighter")
    defer rl.CloseWindow()
    
    // Load custom fonts
    font_bold := rl.LoadFont("assets/fonts/BeaufortforLOL-Bold.ttf")
    font_regular := rl.LoadFont("assets/fonts/BeaufortforLOL-Regular.ttf")
    defer {
        rl.UnloadFont(font_bold)
        rl.UnloadFont(font_regular)
    }
    
    game := vb.init_game()
    defer {
        rl.UnloadTexture(game.background)
        vb.cleanup_game(&game)
    }
    
    rl.SetExitKey(.Q)
    rl.SetTargetFPS(60)
    
    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()
        vb.update_game(&game, dt)
        vb.draw_game(&game, font_bold, font_regular)
    }
}