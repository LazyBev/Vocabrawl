package vocabrawl

import rl "vendor:raylib"

draw_game :: proc(game: ^Game, font_bold: rl.Font, font_regular: rl.Font) {
    rl.BeginDrawing()
    defer rl.EndDrawing()
    
    rl.ClearBackground(rl.BLACK)

    // Draw dark overlay background
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 120})

    // Draw background
    rl.DrawTexture(game.background, 0, 0, rl.WHITE)
    
    switch game.state {
        case .MENU:
            draw_menu(game, font_bold, font_regular)
        case .PLAYING:
            draw_ingame(game, font_regular)
        case .OPTIONS:
            draw_options(game, font_bold, font_regular)
        case .HOW_TO_PLAY:
            draw_how_to(game, font_bold, font_regular)
        case .GAME_OVER:
            draw_game_over(game, font_bold)
    }
}

draw_menu :: proc(game: ^Game, font_bold: rl.Font, font_regular: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Draw dark overlay background
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 120})
    
    // Draw lighter circle in center for the menu area
    circle_radius := f32(300)
    rl.DrawCircle(i32(center_x), i32(center_y), circle_radius, rl.Color{100, 149, 237, 50})
    rl.DrawCircleLines(i32(center_x), i32(center_y), circle_radius, rl.Color{255, 255, 255, 100})

    // Title - stylized like the reference
    title := cstring("Vocabrawl")
    title_size := f32(72)
    title_width := rl.MeasureTextEx(font_bold, title, title_size, 1.0).x
    rl.DrawTextEx(font_bold, title, {center_x - title_width / 2.0, center_y - 200}, title_size, 1.0, rl.WHITE)
    
    // Menu items - vertical stack, simplified style
    menu_items := [5]cstring{"Play Game", "How to Play", "Customise", "Leaderboard", "Quit"}
    menu_len := len(menu_items)
    item_spacing := f32(50)
    start_y := center_y - 30
    
    for i in 0..<menu_len {
        y := start_y + f32(i) * item_spacing
        is_selected := i == game.selected_index
        
        // Draw text only, no rectangles - cleaner look
        text_color := is_selected ? rl.GOLD : rl.WHITE
        text_size := f32(28)
        
        text_width := rl.MeasureTextEx(font_regular, menu_items[i], text_size, 1.0).x
        text_x := center_x - text_width / 2.0
        
        // Draw selection indicator (simple line above selected item)
        if is_selected {
            rl.DrawLine(i32(text_x - 30), i32(y + text_size - 15), i32(text_x - 10), i32(y + text_size - 15), rl.GOLD)
            rl.DrawLine(i32(text_x + text_width + 10), i32(y + text_size - 15), i32(text_x + text_width + 30), i32(y + text_size - 15), rl.GOLD)
        }
        
        rl.DrawTextEx(font_regular, menu_items[i], {text_x, y}, text_size, 1.0, text_color)
    }
    
    // Version and social info at bottom
    version_text := cstring("version 1.0.0")
    version_size := f32(30)
    version_width := rl.MeasureTextEx(font_regular, version_text, version_size, 1.0).x
    rl.DrawTextEx(font_regular, version_text, {20, screen_height - 30}, version_size, 1.0, rl.Color{255, 255, 255, 255})
}

draw_how_to :: proc(game: ^Game, font_bold: rl.Font, font_regular: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Dark overlay
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 150})
    rl.DrawRectangle(100, 80, 800, 640, rl.Color{0, 0, 0, 200})
    rl.DrawRectangleLines(100, 80, 800, 640, rl.Color{255, 215, 0, 150})
    
    // Title
    title := cstring("HOW TO PLAY")
    title_size := f32(56)
    title_width := rl.MeasureTextEx(font_bold, title, title_size, 1.0).x
    rl.DrawTextEx(font_bold, title, {center_x - title_width / 2.0, 110}, title_size, 1.0, rl.GOLD)
    
    // Instructions content
    instructions := [?]cstring{
        "OBJECTIVE:",
        "Test your vocabulary skills in fast-paced word battles!",
        "",
        "CONTROLS:",
        "W/UP ARROW - Move Up",
        "S/DOWN ARROW - Move Down",
        "A/LEFT ARROW - Move Left",
        "D/RIGHT ARROW - Move Right",
        "ENTER/SPACE - Select/Confirm",
        "ESC - Pause/Back",
    }
    
    text_y := f32(200)
    line_height := f32(32)
    
    for i in 0..<len(instructions) {
        text := instructions[i]
        text_size := f32(20)
        
        // Check if it's a header (ends with colon)
        text_str := string(text)
        is_header := len(text_str) > 0 && text_str[len(text_str)-1] == ':'
        
        if is_header {
            text_size = 24
            rl.DrawTextEx(font_bold, text, {150, text_y}, text_size, 1.0, rl.GOLD)
        } else if len(text) == 0 {
            // Empty line, just add spacing
            text_y += line_height * 0.5
            continue
        } else {
            rl.DrawTextEx(font_regular, text, {170, text_y}, text_size, 1.0, rl.WHITE)
        }
        
        text_y += line_height
    }
    
    // Back instruction
    back_text := cstring("Press ESC or ENTER to return to menu")
    back_size := f32(20)
    back_width := rl.MeasureTextEx(font_regular, back_text, back_size, 1.0).x
    rl.DrawTextEx(font_regular, back_text, {center_x - back_width / 2.0, screen_height - 60}, back_size, 1.0, rl.GOLD)
}

draw_options :: proc(game: ^Game, font_bold: rl.Font, font_regular: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Dark overlay
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 120})
    rl.DrawRectangle(0, i32(center_y - 180), 1000, 450, rl.Color{0, 0, 0, 180})
    
    // Title
    title := cstring("OPTIONS")
    title_size := f32(56)
    title_width := rl.MeasureTextEx(font_bold, title, title_size, 1.0).x
    rl.DrawTextEx(font_bold, title, {center_x - title_width / 2.0, center_y - 200}, title_size, 1.0, rl.WHITE)
    
    // Option items
    options := [3]cstring{"Master Volume", "Music Volume", "SFX Volume"}
    volumes := [3]f32{game.master_volume, game.music_volume, game.sfx_volume}
    
    for i in 0..<len(options) {
        y := center_y + f32(i * 70) - 60
        is_selected := i == game.selected_index
        
        // Draw label
        label_size := f32(20)
        text_color := is_selected ? rl.GOLD : rl.WHITE
        rl.DrawTextEx(font_regular, options[i], {center_x - 180.0, y}, label_size, 1.0, text_color)
        
        // Draw volume bar
        bar_width := f32(200)
        bar_height := f32(10)
        bar_x := center_x + 20.0
        bar_y := y + 5
        
        rl.DrawRectangleLinesEx(rl.Rectangle{bar_x, bar_y, bar_width, bar_height}, 1.0, rl.WHITE)
        rl.DrawRectangle(i32(bar_x) + 1, i32(bar_y) + 1, i32((bar_width - 2) * volumes[i]), i32(bar_height - 2), rl.GOLD)
        
        // Draw percentage
        percent_text := rl.TextFormat("%d%%", i32(volumes[i] * 100))
        rl.DrawTextEx(font_regular, percent_text, {bar_x + bar_width + 20.0, bar_y - 3}, 16.0, 1.0, rl.WHITE)
    }
    
}

draw_ingame :: proc(game: ^Game, font: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)

    // Draw dark overlay background
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 120})
    
    // HUD at top with dark background
    rl.DrawRectangle(0, 0, 1000, 80, rl.Color{0, 0, 0, 150})
    
    // Draw HUD
    hud_text := cstring("Vocabrawl")
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
    placeholder := cstring("Game in development...")
    placeholder_width := rl.MeasureTextEx(font, placeholder, 40, 1.0).x
    rl.DrawTextEx(font, placeholder, {center_x - placeholder_width / 2.0, center_y - 100}, 40, 1.0, rl.WHITE)
    
    // Instructions
    instr := cstring("Press ESC to return to menu")
    instr_width := rl.MeasureTextEx(font, instr, 20, 1.0).x
    rl.DrawTextEx(font, instr, {center_x - instr_width / 2.0, screen_height - 50}, 20, 1.0, rl.GRAY)
}

draw_game_over :: proc(game: ^Game, font: rl.Font) {
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Dark overlay
    rl.DrawRectangle(0, 0, 1000, 800, rl.Color{0, 0, 0, 120})
    rl.DrawRectangle(0, i32(center_y - 180), 1000, 450, rl.Color{0, 0, 0, 180})
    
    // Game over text
    game_over_text := cstring("GAME OVER")
    game_over_size := f32(72)
    game_over_width := rl.MeasureTextEx(font, game_over_text, game_over_size, 1.0).x
    rl.DrawTextEx(font, game_over_text, {center_x - game_over_width / 2.0, center_y - 120}, game_over_size, 1.0, rl.RED)
    
    // Score
    score_text := cstring("Final Score: 0")
    score_width := rl.MeasureTextEx(font, score_text, 36, 1.0).x
    rl.DrawTextEx(font, score_text, {center_x - score_width / 2.0, center_y}, 36, 1.0, rl.WHITE)
    
    // Instructions
    instr := cstring("Press ESC to return to menu")
    instr_width := rl.MeasureTextEx(font, instr, 24, 1.0).x
    rl.DrawTextEx(font, instr, {center_x - instr_width / 2.0, center_y + 100}, 24, 1.0, rl.GOLD)
}