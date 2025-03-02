local Concord = require 'concord'

local InputSystem = Concord.system({
    pool = {"position", "movement", "paddle"}
})

function InputSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local movement = e.movement
        local paddle = e.paddle
        
        movement.dy = 0
        
        if not paddle.isAI then
            if love.keyboard.isDown('w') then
                movement.dy = -movement.speed
            end
            if love.keyboard.isDown('s') then
                movement.dy = movement.speed
            end
        end
        
        -- Clamp paddle position to screen
        e.position.y = e.position.y + movement.dy * dt
        e.position.y = math.max(0, math.min(600 - e.size.h, e.position.y))
    end
end

return InputSystem 