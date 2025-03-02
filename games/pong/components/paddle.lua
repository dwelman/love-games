local Concord = require 'concord'

Concord.component("paddle", function(c, isAI)
    c.isAI = isAI or false
    c.score = 0
end)

return Concord.component.paddle 