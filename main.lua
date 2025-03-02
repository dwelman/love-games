local Menu = require 'states.menu'
local GameState = require 'states.game_state'

-- Keep track of key states
local keysPressed = {}

function love.load()
    love.window.setMode(800, 600)
    Menu:init()
end

function love.update(dt)
    if GameState.current_game then
        GameState:update(dt)
        
        -- Check for return to menu
        if love.keyboard.isDown('escape') then
            GameState:quit()
            GameState.current_game = nil
        end
    else
        local selected_game = Menu:update(dt)
        if selected_game then
            print("Loading game: " .. selected_game)
            GameState:load(selected_game)
        end
    end
    
    -- Clear keys pressed after update
    keysPressed = {}
end

function love.draw()
    if GameState.current_game then
        GameState:draw()
    else
        Menu:draw()
    end
end

function love.keypressed(key)
    keysPressed[key] = true
    
    -- Direct handling of return key for menu
    if not GameState.current_game and (key == 'return' or key == 'space') then
        local selected_game = Menu.games[Menu.selected]
        if selected_game then
            print("Loading game via direct key press: " .. selected_game)
            GameState:load(selected_game)
        end
    end
end

-- Custom function to check if a key was pressed this frame
function love.keyboard.wasPressed(key)
    return keysPressed[key] == true
end

function love.quit()
    if GameState.current_game then
        GameState:quit()
    end
end