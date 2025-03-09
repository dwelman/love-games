local Concord = require 'concord'

local CollisionSystem = Concord.system({
    asteroids = {"position", "asteroid", "collider"},
    bullets = {"position", "bullet", "collider"},
    players = {"position", "player", "collider"}
})

function CollisionSystem:init(world)
    self.world = world
    self.uiSystem = nil
    print("Collision System initialized")
    print("  Pools - Asteroids: 0, Bullets: 0, Players: 0")
end

function CollisionSystem:update(dt)
    -- Debug output
    if love.timer.getTime() < 2 then  -- Only print during the first 2 seconds
        print("Collision pools - Asteroids: " .. #self.asteroids .. 
              ", Bullets: " .. #self.bullets .. 
              ", Players: " .. #self.players)
    end
    
    -- Find UI system if not already found
    if not self.uiSystem and self.world.__systems then
        for _, system in ipairs(self.world.__systems) do
            if system.addScore and system.setGameOver then
                self.uiSystem = system
                break
            end
        end
    end
    
    -- Skip collision checks if game is over
    if self.uiSystem and self.uiSystem.gameOver then
        return
    end

    -- Check bullet-asteroid collisions
    for _, bullet in ipairs(self.bullets) do
        for _, asteroid in ipairs(self.asteroids) do
            if self:checkCollision(bullet, asteroid) then
                -- Handle asteroid destruction
                self:destroyAsteroid(asteroid)
                
                -- Destroy the bullet
                bullet:destroy()
                
                -- Break out of the loop since the bullet is destroyed
                break
            end
        end
    end
    
    -- Check player-asteroid collisions
    for _, player in ipairs(self.players) do
        -- Skip if player is invulnerable
        if player.player.invulnerable > 0 then
            goto continue
        end
        
        for _, asteroid in ipairs(self.asteroids) do
            if self:checkCollision(player, asteroid) then
                -- Debug output
                print("Player hit by asteroid!")
                
                -- Handle player collision with asteroid
                self:playerHit(player)
                break
            end
        end
        
        ::continue::
    end
    
    -- Check if all asteroids are destroyed
    if #self.asteroids == 0 and #self.players > 0 then
        -- Start next level
        self:startNextLevel()
    end
end

function CollisionSystem:checkCollision(entityA, entityB)
    local dx = entityA.position.x - entityB.position.x
    local dy = entityA.position.y - entityB.position.y
    local distance = math.sqrt(dx * dx + dy * dy)
    local minDistance = entityA.collider.radius + entityB.collider.radius
    
    return distance < minDistance
end

function CollisionSystem:destroyAsteroid(asteroid)
    local size = asteroid.asteroid.size
    local x, y = asteroid.position.x, asteroid.position.y
    local vx, vy = asteroid.velocity.dx, asteroid.velocity.dy
    
    -- Award points based on asteroid size
    if self.uiSystem then
        if size == "large" then
            self.uiSystem:addScore(20)
        elseif size == "medium" then
            self.uiSystem:addScore(50)
        elseif size == "small" then
            self.uiSystem:addScore(100)
        end
    end
    
    -- Create smaller asteroids if this wasn't a small asteroid
    if size == "large" then
        -- Create 2-3 medium asteroids
        local count = math.random(2, 3)
        for i = 1, count do
            self:createSmallerAsteroid(x, y, vx, vy, "medium")
        end
    elseif size == "medium" then
        -- Create 2-3 small asteroids
        local count = math.random(2, 3)
        for i = 1, count do
            self:createSmallerAsteroid(x, y, vx, vy, "small")
        end
    end
    
    -- Destroy the original asteroid
    asteroid:destroy()
end

function CollisionSystem:createSmallerAsteroid(x, y, parentVx, parentVy, size)
    -- Calculate new velocity with some randomness
    local angle = math.random() * math.pi * 2
    local speed = math.random(50, 100)
    local vx = math.cos(angle) * speed
    local vy = math.sin(angle) * speed
    
    -- Add some of the parent's velocity
    vx = vx + parentVx * 0.5
    vy = vy + parentVy * 0.5
    
    -- Add some random offset to position
    local offset = size == "medium" and 20 or 10
    x = x + math.random(-offset, offset)
    y = y + math.random(-offset, offset)
    
    -- Create the new asteroid
    local asteroid = Concord.entity(self.world)
    asteroid:give("position", x, y)
    asteroid:give("rotation", math.random() * math.pi * 2)
    asteroid:give("velocity", vx, vy, 1.0)
    asteroid:give("asteroid", size)
    asteroid:give("vector", "asteroid_" .. size, math.random(0.8, 1.2), {1, 1, 1, 1})
    asteroid:give("collider", size == "medium" and 20 or 10)
    asteroid:give("rotator", math.random(-1, 1) * math.random(0.5, 1.5))
end

function CollisionSystem:playerHit(player)
    -- Debug output
    print("Player hit! Lives before: " .. player.player.lives)
    
    -- Reduce player lives
    player.player.lives = player.player.lives - 1
    
    print("Player lives after: " .. player.player.lives)
    
    if player.player.lives <= 0 then
        -- Game over
        print("Game Over!")
        if self.uiSystem then
            self.uiSystem:setGameOver(true)
        end
    else
        -- Reset player position and velocity
        player.position.x = 400
        player.position.y = 300
        player.velocity.dx = 0
        player.velocity.dy = 0
        player.rotation.angle = 0
        
        -- Make player invulnerable for a short time
        player.player.invulnerable = 3.0
        print("Player respawned with invulnerability for " .. player.player.invulnerable .. " seconds")
    end
end

function CollisionSystem:startNextLevel()
    -- Increment level in UI
    if self.uiSystem then
        self.uiSystem:nextLevel()
    end
    
    -- Get the current level
    local level = self.uiSystem and self.uiSystem.level or 1
    
    -- Create new asteroids for the next level
    local asteroidCount = math.min(3 + level, 8) -- Cap at 8 asteroids
    
    -- Get reference to the game
    local game = self.world.game
    if game and game.initAsteroids then
        game:initAsteroids(asteroidCount)
    end
end

return CollisionSystem 