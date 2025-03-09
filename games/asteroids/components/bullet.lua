local Concord = require 'concord'

Concord.component("bullet", function(component, lifetime)
    component.lifetime = lifetime or 2.0  -- Lifetime in seconds before the bullet disappears
end) 