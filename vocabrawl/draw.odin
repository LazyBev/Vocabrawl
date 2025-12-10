package vocabrawl

import rl "vendor:raylib"

draw_game :: proc(game: ^Game, font_bold: rl.Font, font_regular: rl.Font) {
    rl.BeginDrawing()
    defer rl.EndDrawing()
    
    rl.ClearBackground(rl.BLACK)
    
    // Draw background
    rl.DrawTexture(game.background, 0, 0, rl.WHITE)
    
    switch game.state {
        case .MENU:
            draw_menu(game, font_bold)
        case .PLAYING:
            draw_ingame(game, font_regular)
        case .OPTIONS:
            draw_options(game, font_bold, font_regular)
        case .GAME_OVER:
            draw_game_over(game, font_bold)
    }
}

draw_menu :: proc(game: ^Game, font: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Semi-transparent overlay
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 150})
    
    // Title
    title := "YOMI HUSTLE STYLE"
    title_size := f32(60)
    title_width := rl.MeasureTextEx(font, title, title_size, 1.0).x
    rl.DrawTextEx(font, title, {center_x - title_width / 2.0, center_y - 150}, title_size, 1.0, rl.GOLD)
    
    // Subtitle
    subtitle := "FIGHTER"
    subtitle_size := f32(32)
    subtitle_width := rl.MeasureTextEx(font, subtitle, subtitle_size, 1.0).x
    rl.DrawTextEx(font, subtitle, {center_x - subtitle_width / 2.0, center_y - 80}, subtitle_size, 1.0, rl.WHITE)
    
    // Menu items
    menu_items := [3]cstring{"Start Game", "Options", "Exit"}
    
    for i in 0..<len(menu_items) {
        y := center_y + f32(i * 60)
        is_selected := i == game.selected_index
        
        // Draw background rectangle
        rect := rl.Rectangle{center_x - 100.0, y, 200.0, 50.0}
        if is_selected {
            rl.DrawRectangleRec(rect, rl.Color{255, 215, 0, 100})
            rl.DrawRectangleLinesEx(rect, 3.0, rl.GOLD)
        } else {
            rl.DrawRectangleLinesEx(rect, 2.0, rl.WHITE)
        }
        
        // Draw text
        text_color := is_selected ? rl.GOLD : rl.WHITE
        text_size := f32(28)
        text_width := rl.MeasureTextEx(font, menu_items[i], text_size, 1.0).x
        rl.DrawTextEx(font, menu_items[i], {center_x - text_width / 2.0, y + 10}, text_size, 1.0, text_color)
    }
    
    // Instructions
    instr := "Use W/S or arrow keys to navigate | Press ENTER to select"
    instr_size := f32(14)
    instr_width := rl.MeasureTextEx(font, instr, instr_size, 1.0).x
    rl.DrawTextEx(font, instr, {center_x - instr_width / 2.0, screen_height - 40}, instr_size, 1.0, rl.GRAY)
}

draw_options :: proc(game: ^Game, font_bold: rl.Font, font_regular: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Semi-transparent overlay
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 150})
    
    // Title
    title := "OPTIONS"
    title_size := f32(48)
    title_width := rl.MeasureTextEx(font_bold, title, title_size, 1.0).x
    rl.DrawTextEx(font_bold, title, {center_x - title_width / 2.0, center_y - 200}, title_size, 1.0, rl.GOLD)
    
    // Option items
    options := [3]cstring{"Master Volume", "Music Volume", "SFX Volume"}
    volumes := [3]f32{game.master_volume, game.music_volume, game.sfx_volume}
    
    for i in 0..<len(options) {
        y := center_y + f32(i * 80) - 80
        is_selected := i == game.selected_index
        
        // Draw background
        rect := rl.Rectangle{center_x - 200.0, y, 400.0, 70.0}
        if is_selected {
            rl.DrawRectangleRec(rect, rl.Color{255, 215, 0, 50})
            rl.DrawRectangleLinesEx(rect, 3.0, rl.GOLD)
        } else {
            rl.DrawRectangleLinesEx(rect, 2.0, rl.WHITE)
        }
        
        // Draw label
        label_size := f32(22)
        rl.DrawTextEx(font_regular, options[i], {center_x - 190.0, y + 5}, label_size, 1.0, rl.WHITE)
        
        // Draw volume bar
        bar_width := f32(250)
        bar_height := f32(12)
        bar_x := center_x - 120.0
        bar_y := y + 38.0
        
        rl.DrawRectangleLinesEx(rl.Rectangle{bar_x, bar_y, bar_width, bar_height}, 2.0, rl.WHITE)
        rl.DrawRectangle(i32(bar_x) + 1, i32(bar_y) + 1, i32((bar_width - 2) * volumes[i]), i32(bar_height - 2), rl.GOLD)
        
        // Draw percentage
        percent_text := rl.TextFormat("%d%%", i32(volumes[i] * 100))
        rl.DrawTextEx(font_regular, percent_text, {bar_x + bar_width + 15.0, bar_y - 2}, 18.0, 1.0, rl.WHITE)
    }
    
    // Instructions
    instr_size := f32(14)
    instr1 := "Use W/S to navigate | A/D or Arrows to adjust | Mouse scroll to adjust"
    instr_width := rl.MeasureTextEx(font_regular, instr1, instr_size, 1.0).x
    rl.DrawTextEx(font_regular, instr1, {center_x - instr_width / 2.0, screen_height - 60}, instr_size, 1.0, rl.GRAY)
    
    instr2 := "Press ESC to go back"
    instr2_width := rl.MeasureTextEx(font_regular, instr2, instr_size, 1.0).x
    rl.DrawTextEx(font_regular, instr2, {center_x - instr2_width / 2.0, screen_height - 35}, instr_size, 1.0, rl.GRAY)
}

draw_ingame :: proc(game: ^Game, font: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    
    // Semi-transparent overlay for HUD
    rl.DrawRectangle(0, 0, 1000, 80, rl.Color{0, 0, 0, 100})
    
    // Draw HUD
    hud_text := "YOMI HUSTLE STYLE - In-Game"
    rl.DrawTextEx(font, hud_text, {20, 20}, 28, 1.0, rl.GOLD)
    
    // Volume indicators
    volume_text := rl.TextFormat("Master: %d%% | Music: %d%% | SFX: %d%%", 
        i32(game.master_volume * 100),
        i32(game.music_volume * 100),
        i32(game.sfx_volume * 100))
    rl.DrawText(volume_text, 20, 55, 14, rl.WHITE)
    
    // Placeholder for game content
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    placeholder := "Game in development..."
    placeholder_width := rl.MeasureTextEx(font, placeholder, 40, 1.0).x
    rl.DrawTextEx(font, placeholder, {center_x - placeholder_width / 2.0, center_y - 100}, 40, 1.0, rl.WHITE)
    
    // Instructions
    instr := "Press ESC to return to menu"
    instr_width := rl.MeasureTextEx(font, instr, 20, 1.0).x
    rl.DrawTextEx(font, instr, {center_x - instr_width / 2.0, screen_height - 50}, 20, 1.0, rl.GRAY)
}

draw_game_over :: proc(game: ^Game, font: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Semi-transparent overlay
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 180})
    
    // Game over text
    game_over_text := "GAME OVER"
    game_over_size := f32(72)
    game_over_width := rl.MeasureTextEx(font, game_over_text, game_over_size, 1.0).x
    rl.DrawTextEx(font, game_over_text, {center_x - game_over_width / 2.0, center_y - 120}, game_over_size, 1.0, rl.RED)
    
    // Score placeholder
    score_text := "Final Score: 0"
    score_width := rl.MeasureTextEx(font, score_text, 36, 1.0).x
    rl.DrawTextEx(font, score_text, {center_x - score_width / 2.0, center_y}, 36, 1.0, rl.WHITE)
    
    // Instructions
    instr := "Press ESC to return to menu"
    instr_width := rl.MeasureTextEx(font, instr, 24, 1.0).x
    rl.DrawTextEx(font, instr, {center_x - instr_width / 2.0, center_y + 100}, 24, 1.0, rl.GOLD)
}