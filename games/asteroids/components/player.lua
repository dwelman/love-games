local Concord = require 'concord'

Concord.component("player", function(component, rotationSpeed, thrustPower, maxSpeed)
    component.rotationSpeed = rotationSpeed or 3.5  -- Rotation speed in radians per second
    component.thrustPower = thrustPower or 200      -- Acceleration when thrusting
    component.maxSpeed = maxSpeed or 300            -- Maximum speed
    component.thrusting = false                     -- Whether the player is currently thrusting
    component.shootCooldown = 0                     -- Cooldown timer for shooting
    component.shootDelay = 0.25                     -- Delay between shots in seconds
    component.lives = 3                             -- Number of lives
    component.invulnerable = 0                      -- Invulnerability timer after respawning
end) 