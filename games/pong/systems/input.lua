local Concord = require 'concord'

local InputSystem = Concord.system({
    pool = {"position", "movement", "paddle"}
})

function InputSystem:init(world)
    self.world = world
    print("Pong Input System initialized")
end

function InputSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local movement = e.movement
        local paddle = e.paddle
        
        movement.dy = 0
        
        if not paddle.isAI then
            -- Left paddle controls (Player 1) - Support both W/S and Up/Down
            if e.position.x < 400 then
                if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
                    movement.dy = -movement.speed
                end
                if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
                    movement.dy = movement.speed
                end
            else
                -- Right paddle controls (Player 2, if not AI)
                if love.keyboard.isDown('up') then
                    movement.dy = -movement.speed
                end
                if love.keyboard.isDown('down') then
                    movement.dy = movement.speed
                end
            end
        end
        
        -- Clamp paddle position to screen
        e.position.y = e.position.y + movement.dy * dt
        e.position.y = math.max(0, math.min(600 - e.size.h, e.position.y))
    end
end

return InputSystem 