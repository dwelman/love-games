local Concord = require 'concord'

local function checkCollision(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and
           ax + aw > bx and
           ay < by + bh and
           ay + ah > by
end

local function resolveCollision(ball, paddle)
    -- Determine which side of the paddle was hit
    local ballCenter = ball.position.x + ball.size.w / 2
    local paddleCenter = paddle.position.x + paddle.size.w / 2
    
    -- Ball hit the paddle
    if ballCenter < paddleCenter then
        -- Hit from left side
        ball.position.x = paddle.position.x - ball.size.w
    else
        -- Hit from right side
        ball.position.x = paddle.position.x + paddle.size.w
    end
    
    -- Reverse x direction and increase speed slightly
    ball.movement.dx = -ball.movement.dx * 1.1
    
    -- Calculate y velocity based on where the ball hits the paddle
    local hitPos = (ball.position.y + ball.size.h/2 - paddle.position.y) / paddle.size.h
    hitPos = math.max(0, math.min(1, hitPos)) -- Clamp between 0 and 1
    -- Convert hit position to angle (-45 to 45 degrees)
    local angle = (hitPos - 0.5) * math.pi/2
    
    -- Set new velocities based on angle and current speed
    local speed = math.sqrt(ball.movement.dx * ball.movement.dx + ball.movement.dy * ball.movement.dy)
    ball.movement.dy = math.sin(angle) * speed
end

local CollisionSystem = Concord.system({
    paddles = {"position", "size", "paddle"},
    balls = {"position", "movement", "ball", "size"}
})

function CollisionSystem:update(dt)
    for _, ball in ipairs(self.balls) do
        local nextX = ball.position.x + ball.movement.dx * dt
        local nextY = ball.position.y + ball.movement.dy * dt
        
        -- First move in X direction and check collisions
        ball.position.x = nextX
        
        -- Check paddle collisions
        for _, paddle in ipairs(self.paddles) do
            if checkCollision(
                ball.position.x, ball.position.y, ball.size.w, ball.size.h,
                paddle.position.x, paddle.position.y, paddle.size.w, paddle.size.h
            ) then
                resolveCollision(ball, paddle)
                break
            end
        end
        
        -- Then move in Y direction
        ball.position.y = nextY
        
        -- Bounce off top and bottom walls
        if ball.position.y < 0 then
            ball.position.y = 0
            ball.movement.dy = -ball.movement.dy
        elseif ball.position.y + ball.size.h > 600 then
            ball.position.y = 600 - ball.size.h
            ball.movement.dy = -ball.movement.dy
        end
    end
end

return CollisionSystem 