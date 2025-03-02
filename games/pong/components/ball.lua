local Concord = require 'concord'

Concord.component("ball", function(c)
    c.speed = 300
end)

return Concord.component.ball 