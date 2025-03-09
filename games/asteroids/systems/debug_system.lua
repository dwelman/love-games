local Concord = require 'concord'

local DebugSystem = Concord.system()

function DebugSystem:init(world)
    self.world = world
    self.enabled = false  -- Debug mode off by default
    self.font = love.graphics.newFont(12)
    print("Debug System initialized (disabled by default)")
end

function DebugSystem:draw()
    if not self.enabled then return end
    
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 1, 0, 1)
    
    -- Count entities by type
    local playerCount = 0
    local bulletCount = 0
    local asteroidCount = 0
    local totalEntities = 0
    
    for _, entity in ipairs(self.world:getEntities()) do
        totalEntities = totalEntities + 1
        
        if entity.player then
            playerCount = playerCount + 1
        elseif entity.bullet then
            bulletCount = bulletCount + 1
        elseif entity.asteroid then
            asteroidCount = asteroidCount + 1
        end
    end
    
    -- Display entity counts
    local y = 500
    love.graphics.print("DEBUG INFO:", 600, y)
    y = y + 20
    love.graphics.print("Total Entities: " .. totalEntities, 600, y)
    y = y + 15
    love.graphics.print("Players: " .. playerCount, 600, y)
    y = y + 15
    love.graphics.print("Bullets: " .. bulletCount, 600, y)
    y = y + 15
    love.graphics.print("Asteroids: " .. asteroidCount, 600, y)
    
    -- Display player info if exists
    for _, entity in ipairs(self.world:getEntities()) do
        if entity.player then
            y = y + 20
            love.graphics.print("Player Position: " .. math.floor(entity.position.x) .. ", " .. math.floor(entity.position.y), 600, y)
            y = y + 15
            love.graphics.print("Player Velocity: " .. math.floor(entity.velocity.dx) .. ", " .. math.floor(entity.velocity.dy), 600, y)
            y = y + 15
            love.graphics.print("Player Lives: " .. entity.player.lives, 600, y)
            y = y + 15
            love.graphics.print("Invulnerable: " .. string.format("%.1f", entity.player.invulnerable), 600, y)
            break
        end
    end
    
    -- Reset font
    love.graphics.setFont(oldFont)
    love.graphics.setColor(1, 1, 1, 1)
end

function DebugSystem:toggleDebug()
    self.enabled = not self.enabled
    print("Debug display " .. (self.enabled and "enabled" or "disabled"))
    
    -- Notify other systems about debug state change
    self.world:emit("debugStateChanged", self.enabled)
end

-- Handle keypresses for toggling debug mode
function DebugSystem:keypressed(key)
    if key == "f1" then
        self:toggleDebug()
    end
end

function DebugSystem:isDebugEnabled()
    return self.enabled
end

return DebugSystem 