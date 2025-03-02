local Concord = require 'concord'

Concord.component("movement", function(c, speed)
    c.speed = speed or 200
    c.dx = 0
    c.dy = 0
end)

return Concord.component.movement 