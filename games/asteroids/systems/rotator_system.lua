local Concord = require 'concord'

local RotatorSystem = Concord.system({
    pool = {"rotation", "rotator"}
})

function RotatorSystem:update(dt)
    for _, entity in ipairs(self.pool) do
        -- Apply rotation based on rotator speed
        entity.rotation.angle = entity.rotation.angle + entity.rotator.speed * dt
    end
end

return RotatorSystem 