local Concord = require 'concord'

Concord.component("collider", function(component, radius)
    component.radius = radius or 10  -- Collision radius
end) 