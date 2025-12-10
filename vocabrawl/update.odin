package vocabrawl

import "core:math"
import rl "vendor:raylib"

update_game :: proc(game: ^Game, dt: f32) {
    if game.state == .MENU {
        update_menu(game)
    } else if game.state == .OPTIONS {
        update_options(game)
    } else if game.state == .PLAYING {
        update_ingame(game, dt)
    } else if game.state == .GAME_OVER {
        update_game_over(game)
    }
    
    // Debug keys (can be removed in production)
    update_debug_keys(game)
}

update_menu :: proc(game: ^Game) {
    menu_len := 5
    
    // Keyboard navigation
    if rl.IsKeyPressed(.S) || rl.IsKeyPressed(.DOWN) {
        game.selected_index = (game.selected_index + 1) % menu_len
    } else if rl.IsKeyPressed(.W) || rl.IsKeyPressed(.UP) {
        game.selected_index = (game.selected_index - 1 + menu_len) % menu_len
    }
    
    // Mouse navigation and selection
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    // Handle mouse hover and click on menu items
    for i in 0..<menu_len {
        y := center_y + f32(i * 48) - 40
        rect := rl.Rectangle{center_x - 70.0, y, 140.0, 38.0}
        
        // Update selection on hover
        if rl.CheckCollisionPointRec(rl.GetMousePosition(), rect) {
            game.selected_index = i
            
            // Handle click
            if rl.IsMouseButtonPressed(.LEFT) {
                handle_menu_selection(game, i)
            }
        }
    }
    
    // Keyboard activation
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.SPACE) {
        handle_menu_selection(game, game.selected_index)
    }
}

handle_menu_selection :: proc(game: ^Game, index: int) {
    switch index {
        case 0:
            game.state = .PLAYING
        case 1:
            // How to Play
            game.state = .PLAYING
        case 2:
            // Customise
            game.state = .OPTIONS
            game.selected_index = 0
        case 3:
            // Leaderboard
            game.state = .PLAYING
        case 4:
            rl.CloseWindow()
    }
}

update_options :: proc(game: ^Game) {
    option_len := 3
    
    // Keyboard navigation
    if rl.IsKeyPressed(.S) || rl.IsKeyPressed(.DOWN) {
        game.selected_index = (game.selected_index + 1) % option_len
    } else if rl.IsKeyPressed(.W) || rl.IsKeyPressed(.UP) {
        game.selected_index = (game.selected_index - 1 + option_len) % option_len
    }
    
    // Adjust volume with arrow keys
    if rl.IsKeyPressed(.A) || rl.IsKeyPressed(.LEFT) {
        adjust_volume(game, game.selected_index, -0.1)
    } else if rl.IsKeyPressed(.D) || rl.IsKeyPressed(.RIGHT) {
        adjust_volume(game, game.selected_index, 0.1)
    }
    
    // Mouse navigation and adjustment
    screen_width :: f32(1000)
    screen_height :: f32(800)
    center_x := screen_width / 2.0
    center_y := screen_height / 2.0
    
    for i in 0..<option_len {
        y := center_y + f32(i * 60) + 20.0
        rect := rl.Rectangle{center_x - 150.0, y, 300.0, 50.0}
        
        if rl.CheckCollisionPointRec(rl.GetMousePosition(), rect) {
            game.selected_index = i
            
            // Volume adjustment with mouse scroll
            scroll := rl.GetMouseWheelMove()
            if scroll > 0 {
                adjust_volume(game, i, 0.05)
            } else if scroll < 0 {
                adjust_volume(game, i, -0.05)
            }
        }
    }
    
    // Back to menu
    if rl.IsKeyPressed(.ESCAPE) {
        game.state = .MENU
        game.selected_index = 0
    }
}

adjust_volume :: proc(game: ^Game, index: int, delta: f32) {
    switch index {
        case 0:
            game.master_volume = math.clamp(game.master_volume + delta, 0.0, 1.0)
        case 1:
            game.music_volume = math.clamp(game.music_volume + delta, 0.0, 1.0)
        case 2:
            game.sfx_volume = math.clamp(game.sfx_volume + delta, 0.0, 1.0)
    }
}

update_ingame :: proc(game: ^Game, dt: f32) {
    // In-game controls and logic
    if rl.IsKeyPressed(.ESCAPE) {
        game.state = .MENU
        game.selected_index = 0
    }
    
    // Add gameplay logic here
}

update_game_over :: proc(game: ^Game) {
    // Game over logic
    if rl.IsKeyPressed(.ESCAPE) {
        game.state = .MENU
        game.selected_index = 0
    }
}

update_debug_keys :: proc(game: ^Game) {
    if rl.IsKeyPressed(.ONE) {
        game.state = .MENU
        game.selected_index = 0
    } else if rl.IsKeyPressed(.TWO) {
        game.state = .PLAYING
    } else if rl.IsKeyPressed(.THREE) {
        game.state = .OPTIONS
        game.selected_index = 0
    } else if rl.IsKeyPressed(.FOUR) {
        game.state = .GAME_OVER
    }
}