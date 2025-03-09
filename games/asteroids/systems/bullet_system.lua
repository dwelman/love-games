local Concord = require 'concord'

local BulletSystem = Concord.system({
    pool = {"position", "bullet"}
})

function BulletSystem:init(world)
    self.world = world
    print("Bullet System initialized")
end

function BulletSystem:update(dt)
    -- Debug output
    if love.timer.getTime() < 2 then  -- Only print during the first 2 seconds
        print("Active bullets: " .. #self.pool)
    end
    
    for _, entity in ipairs(self.pool) do
        -- Update bullet lifetime
        entity.bullet.lifetime = entity.bullet.lifetime - dt
        
        -- Remove bullet if lifetime is expired
        if entity.bullet.lifetime <= 0 then
            print("Bullet expired and destroyed")
            entity:destroy()
        end
    end
end

return BulletSystem 