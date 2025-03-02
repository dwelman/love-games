local Concord = require 'concord'

local BallSystem = Concord.system({
    pool = {"position", "movement", "ball", "size"}
})

function BallSystem:init(world)
    self.world = world
    self.resetBall = true
end

function BallSystem:resetBallPosition(ball)
    ball.position.x = 400
    ball.position.y = 300
    ball.movement.dx = ball.ball.speed * (math.random() > 0.5 and 1 or -1)
    ball.movement.dy = ball.ball.speed * (math.random() * 2 - 1) * 0.5
end

function BallSystem:update(dt)
    for _, ball in ipairs(self.pool) do
        if self.resetBall then
            self:resetBallPosition(ball)
            self.resetBall = false
        end
        
        ball.position.x = ball.position.x + ball.movement.dx * dt
        ball.position.y = ball.position.y + ball.movement.dy * dt
        
        -- Bounce off top and bottom
        if ball.position.y <= 0 or ball.position.y + ball.size.h >= 600 then
            ball.movement.dy = -ball.movement.dy
            ball.position.y = math.max(0, math.min(600 - ball.size.h, ball.position.y))
        end
        
        -- Score points and reset ball
        if ball.position.x < 0 then
            self.world:emit("score", "right")
            self.resetBall = true
        elseif ball.position.x > 800 then
            self.world:emit("score", "left")
            self.resetBall = true
        end
    end
end

return BallSystem 