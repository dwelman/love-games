local Concord = require 'concord'

local MovementSystem = Concord.system({
    pool = {"position", "velocity"}
})

function MovementSystem:init(world)
    self.world = world
    self.screenWidth = 800
    self.screenHeight = 600
end

function MovementSystem:update(dt)
    for _, entity in ipairs(self.pool) do
        local position = entity.position
        local velocity = entity.velocity
        
        -- Apply velocity to position
        position.x = position.x + velocity.dx * dt
        position.y = position.y + velocity.dy * dt
        
        -- Apply drag if not an asteroid
        if not entity.asteroid then
            velocity.dx = velocity.dx * velocity.drag
            velocity.dy = velocity.dy * velocity.drag
            
            -- Stop very slow movement
            if math.abs(velocity.dx) < 0.1 then velocity.dx = 0 end
            if math.abs(velocity.dy) < 0.1 then velocity.dy = 0 end
        end
        
        -- Screen wrapping
        if position.x < 0 then
            position.x = position.x + self.screenWidth
        elseif position.x > self.screenWidth then
            position.x = position.x - self.screenWidth
        end
        
        if position.y < 0 then
            position.y = position.y + self.screenHeight
        elseif position.y > self.screenHeight then
            position.y = position.y - self.screenHeight
        end
    end
end

return MovementSystem 