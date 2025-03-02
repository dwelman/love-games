local Concord = require 'concord'

Concord.component("size", function(c, w, h)
    c.w = w or 32
    c.h = h or 32
end)

return Concord.component.size 