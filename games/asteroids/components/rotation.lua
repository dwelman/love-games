local Concord = require 'concord'

Concord.component("rotation", function(component, angle)
    component.angle = angle or 0
end) 