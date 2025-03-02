local Concord = require 'concord'

local AISystem = Concord.system({
    paddles = {"position", "movement", "paddle", "size"},
    balls = {"position", "ball", "movement"}
})

function AISystem:update(dt)
    for _, paddle in ipairs(self.paddles) do
        if paddle.paddle.isAI then
            for _, ball in ipairs(self.balls) do
                if ball.movement.dx > 0 then -- Only move if ball is coming towards AI
                    local targetY = ball.position.y - (paddle.size.h / 2)
                    local diff = targetY - paddle.position.y
                    
                    if math.abs(diff) > 10 then -- Add some delay to make it beatable
                        paddle.movement.dy = diff > 0 and paddle.movement.speed or -paddle.movement.speed
                    else
                        paddle.movement.dy = 0
                    end
                    
                    -- Apply movement
                    paddle.position.y = paddle.position.y + paddle.movement.dy * dt
                    paddle.position.y = math.max(0, math.min(600 - paddle.size.h, paddle.position.y))
                end
            end
        end
    end
end

return AISystem 