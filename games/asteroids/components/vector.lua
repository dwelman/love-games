local Concord = require 'concord'

Concord.component("vector", function(component, shape, scale, color)
    component.shape = shape or "default" -- Name of the shape to render
    component.scale = scale or 1.0       -- Scale factor for the shape
    component.color = color or {1, 1, 1, 1} -- RGBA color (white by default)
    component.lineWidth = 2              -- Line width for drawing
    component.closed = true              -- Whether the shape is closed (connected last point to first)
end) 