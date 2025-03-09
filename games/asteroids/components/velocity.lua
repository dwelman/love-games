local Concord = require 'concord'

Concord.component("velocity", function(component, dx, dy, drag)
    component.dx = dx or 0
    component.dy = dy or 0
    component.drag = drag or 0.98 -- Default drag factor
end) 