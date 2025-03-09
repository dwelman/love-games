local Concord = require 'concord'

local UISystem = Concord.system({
    players = {"player"}
})

function UISystem:init(world)
    self.world = world
    self.score = 0
    self.level = 1
    self.gameOver = false
end

function UISystem:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(14))
    
    -- Draw score
    love.graphics.print("SCORE: " .. self.score, 20, 20)
    
    -- Draw level
    love.graphics.print("LEVEL: " .. self.level, 20, 40)
    
    -- Draw lives
    if #self.players > 0 then
        local player = self.players[1]
        love.graphics.print("LIVES: " .. player.player.lives, 20, 60)
        
        -- Draw ship icons for lives
        for i = 1, player.player.lives do
            self:drawShipIcon(120 + i * 25, 65)
        end
        
        -- Draw invulnerability indicator
        if player.player.invulnerable > 0 then
            love.graphics.setColor(1, 1, 1, 0.5 + 0.5 * math.sin(love.timer.getTime() * 10))
            love.graphics.print("SHIELD", 20, 80)
        end
    end
    
    -- Draw game over message
    if self.gameOver then
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf("GAME OVER", 0, 250, 800, "center")
        
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Press ENTER to restart", 0, 300, 800, "center")
    end
end

function UISystem:drawShipIcon(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    
    -- Draw a small ship icon
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(-math.pi/2) -- Rotate to point right
    love.graphics.scale(0.8, 0.8)
    
    -- Ship shape
    love.graphics.line(0, -5, -3.5, 5, 0, 2.5, 3.5, 5, 0, -5)
    
    love.graphics.pop()
end

function UISystem:addScore(points)
    self.score = self.score + points
end

function UISystem:setGameOver(isGameOver)
    self.gameOver = isGameOver
    
    -- If game over, destroy the player ship
    if isGameOver then
        for _, entity in ipairs(self.players) do
            entity:destroy()
        end
    end
end

function UISystem:nextLevel()
    self.level = self.level + 1
end

function UISystem:resetGame()
    -- Reset game state
    self.score = 0
    self.level = 1
    self.gameOver = false
    
    -- Get reference to the game
    local game = self.world.game
    if game then
        -- Create a new player ship
        game:createPlayerShip()
        
        -- Initialize asteroid field
        game:initAsteroids(3)
    end
    
    print("Game reset")
end

function UISystem:keypressed(key)
    -- Handle restart on Enter key when game is over
    if self.gameOver and (key == "return" or key == "kpenter") then
        self:resetGame()
    end
end

return UISystem 