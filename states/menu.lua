local Menu = {
    games = {},
    selected = 1
}

function Menu:init()
    -- Scan games directory for available games
    local games = love.filesystem.getDirectoryItems("games")
    for _, game in ipairs(games) do
        -- Only add directories
        if love.filesystem.getInfo("games/" .. game, "directory") then
            table.insert(self.games, game)
        end
    end
end

function Menu:update(dt)
    -- Handle menu navigation
    if love.keyboard.wasPressed('up') then
        self.selected = ((self.selected - 2) % #self.games) + 1
    elseif love.keyboard.wasPressed('down') then
        self.selected = (self.selected % #self.games) + 1
    elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        print("Selected game: " .. self.games[self.selected])
        -- Load selected game
        if self.games[self.selected] then
            return self.games[self.selected]
        end
    elseif love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    return nil
end

function Menu:draw()
    -- Draw menu background
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw title
    love.graphics.setColor(1, 1, 1)
    local title = "Game Selection"
    love.graphics.printf(title, 0, 50, love.graphics.getWidth(), "center")
    
    -- Draw game list
    local startY = 200
    local spacing = 40
    for i, game in ipairs(self.games) do
        if i == self.selected then
            love.graphics.setColor(1, 1, 0)
            love.graphics.printf("> " .. game, 0, startY + (i-1) * spacing, love.graphics.getWidth(), "center")
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(game, 0, startY + (i-1) * spacing, love.graphics.getWidth(), "center")
        end
    end
    
    -- Draw instructions
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.printf("Use UP/DOWN to select, ENTER to play", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
end

return Menu 