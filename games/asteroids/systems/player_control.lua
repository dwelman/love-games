local Concord = require 'concord'

local PlayerControlSystem = Concord.system({
    pool = {"position", "rotation", "velocity", "player"}
})

function PlayerControlSystem:init(world)
    self.world = world
    self.gameStartTime = love.timer.getTime()
    self.ignoreInitialSpace = true  -- Flag to ignore initial space press
    print("Player Control System initialized")
end

function PlayerControlSystem:update(dt)
    -- Debug output for player entities
    if love.timer.getTime() < 2 then  -- Only print during the first 2 seconds
        print("Player entities: " .. #self.pool)
    end
    
    -- Reset the ignore flag after a short delay
    if self.ignoreInitialSpace and love.timer.getTime() - self.gameStartTime > 0.5 then
        self.ignoreInitialSpace = false
    end
    
    for _, entity in ipairs(self.pool) do
        local position = entity.position
        local rotation = entity.rotation
        local velocity = entity.velocity
        local player = entity.player
        
        -- Update invulnerability timer
        if player.invulnerable > 0 then
            player.invulnerable = player.invulnerable - dt
        end
        
        -- Update shoot cooldown
        if player.shootCooldown > 0 then
            player.shootCooldown = player.shootCooldown - dt
        end
        
        -- Rotation control - support both arrow keys and A/D
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            rotation.angle = rotation.angle - player.rotationSpeed * dt
        end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            rotation.angle = rotation.angle + player.rotationSpeed * dt
        end
        
        -- Thrust control - support both up arrow and W
        player.thrusting = love.keyboard.isDown("up") or love.keyboard.isDown("w")
        if player.thrusting then
            -- Calculate thrust vector based on ship's rotation
            local thrustX = math.sin(rotation.angle) * player.thrustPower * dt
            local thrustY = -math.cos(rotation.angle) * player.thrustPower * dt
            
            -- Apply thrust to velocity
            velocity.dx = velocity.dx + thrustX
            velocity.dy = velocity.dy + thrustY
            
            -- Limit maximum speed
            local speed = math.sqrt(velocity.dx^2 + velocity.dy^2)
            if speed > player.maxSpeed then
                local scale = player.maxSpeed / speed
                velocity.dx = velocity.dx * scale
                velocity.dy = velocity.dy * scale
            end
        end
        
        -- Shooting control - ignore initial space press when game starts
        if not self.ignoreInitialSpace and love.keyboard.isDown("space") and player.shootCooldown <= 0 then
            self:fireBullet(entity)
            player.shootCooldown = player.shootDelay
        end
    end
end

function PlayerControlSystem:keypressed(key)
    -- If space is pressed and we're ignoring initial space, reset the cooldown
    if key == "space" and self.ignoreInitialSpace then
        for _, entity in ipairs(self.pool) do
            entity.player.shootCooldown = entity.player.shootDelay
        end
    end
end

function PlayerControlSystem:fireBullet(player)
    -- Debug output
    print("Firing bullet from player at position: " .. player.position.x .. ", " .. player.position.y)
    
    local bullet = Concord.entity(self.world)
    
    -- Calculate bullet position at the nose of the ship
    local noseX = player.position.x + math.sin(player.rotation.angle) * 12
    local noseY = player.position.y - math.cos(player.rotation.angle) * 12
    
    -- Calculate bullet velocity
    local bulletSpeed = 500
    local bulletDx = math.sin(player.rotation.angle) * bulletSpeed
    local bulletDy = -math.cos(player.rotation.angle) * bulletSpeed
    
    -- Add player's velocity to bullet velocity
    bulletDx = bulletDx + player.velocity.dx * 0.5
    bulletDy = bulletDy + player.velocity.dy * 0.5
    
    -- Create bullet entity
    bullet:give("position", noseX, noseY)
    bullet:give("rotation", player.rotation.angle)
    bullet:give("velocity", bulletDx, bulletDy, 1.0) -- No drag for bullets
    bullet:give("vector", "bullet", 1.0, {1, 1, 1, 1})
    bullet:give("collider", 3)
    bullet:give("bullet", 2) -- Lifetime in seconds
end

return PlayerControlSystem 