local Concord = require 'concord'

Concord.component("rotator", function(component, speed)
    component.speed = speed or 1.0  -- Rotation speed in radians per second
end) 