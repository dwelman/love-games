local Concord = require 'concord'

Concord.component("position", function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

return Concord.component.position 