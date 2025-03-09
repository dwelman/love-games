local Concord = require 'concord'

local DebugSystem = Concord.system()

function DebugSystem:init(world)
    self.world = world
    self.enabled = false  -- Debug mode off by default
    self.font = love.graphics.newFont(12)
    print("Pong Debug System initialized (disabled by default)")
end

function DebugSystem:draw()
    if not self.enabled then return end
    
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 1, 0, 1)
    
    -- Count entities by type
    local paddleCount = 0
    local ballCount = 0
    local totalEntities = 0
    
    for _, entity in ipairs(self.world:getEntities()) do
        totalEntities = totalEntities + 1
        
        if entity.paddle then
            paddleCount = paddleCount + 1
        elseif entity.ball then
            ballCount = ballCount + 1
        end
    end
    
    -- Display entity counts
    local y = 20
    love.graphics.print("DEBUG INFO:", 600, y)
    y = y + 20
    love.graphics.print("Total Entities: " .. totalEntities, 600, y)
    y = y + 15
    love.graphics.print("Paddles: " .. paddleCount, 600, y)
    y = y + 15
    love.graphics.print("Balls: " .. ballCount, 600, y)
    
    -- Display ball info if exists
    for _, entity in ipairs(self.world:getEntities()) do
        if entity.ball then
            y = y + 20
            love.graphics.print("Ball Position: " .. math.floor(entity.position.x) .. ", " .. math.floor(entity.position.y), 600, y)
            y = y + 15
            love.graphics.print("Ball Velocity: " .. math.floor(entity.movement.dx) .. ", " .. math.floor(entity.movement.dy), 600, y)
            break
        end
    end
    
    -- Display paddle info
    y = y + 20
    for i, entity in ipairs(self.world:getEntities()) do
        if entity.paddle then
            local paddleType = entity.paddle.isAI and "AI" or "Player"
            love.graphics.print(paddleType .. " Paddle: " .. math.floor(entity.position.x) .. ", " .. math.floor(entity.position.y), 600, y)
            y = y + 15
        end
    end
    
    -- Draw collision boxes for all entities
    for _, entity in ipairs(self.world:getEntities()) do
        if entity.position and entity.size then
            love.graphics.setColor(1, 0, 0, 0.3)
            love.graphics.rectangle("line", 
                entity.position.x, 
                entity.position.y, 
                entity.size.w, 
                entity.size.h)
        end
    end
    
    -- Reset font and color
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