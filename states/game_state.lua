local GameState = {
    current_game = nil,
    world = nil
}

function GameState:load(game_name)
    -- Clear previous game state if exists
    if self.world then
        self.world = nil
        collectgarbage()
    end
    
    -- Set current game for path resolution
    _G.CURRENT_GAME = game_name
    
    -- Add game-specific paths to package.path
    local game_path = love.filesystem.getSource() .. "/games/" .. game_name
    package.path = package.path .. ";" .. game_path .. "/?.lua"
    package.path = package.path .. ";" .. game_path .. "/?/init.lua"
    package.path = package.path .. ";" .. game_path .. "/components/?.lua"
    package.path = package.path .. ";" .. game_path .. "/systems/?.lua"
    package.path = package.path .. ";" .. game_path .. "/utils/?.lua"
    
    -- Load game module
    local status, game = pcall(require, "games." .. game_name .. ".game")
    if not status then
        print("Failed to load game: " .. game_name)
        print(game) -- Print the error message
        return false
    end
    
    self.current_game = game
    self.current_game:init()
    return true
end

function GameState:update(dt)
    if self.current_game then
        self.current_game:update(dt)
    end
end

function GameState:draw()
    if self.current_game then
        self.current_game:draw()
    end
end

function GameState:keypressed(key)
    if self.current_game and self.current_game.keypressed then
        self.current_game:keypressed(key)
    end
end

function GameState:quit()
    if self.current_game and self.current_game.quit then
        self.current_game:quit()
    end
    -- Clear game-specific paths
    _G.CURRENT_GAME = nil
end

return GameState 