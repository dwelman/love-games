local Concord = require 'concord'

local ScoreSystem = Concord.system()

function ScoreSystem:init(world)
    self.world = world
end

function ScoreSystem:score(scorer)
    for _, e in ipairs(self.world:getEntities()) do
        if e.paddle then
            if (scorer == "left" and e.position.x < 400) or
               (scorer == "right" and e.position.x > 400) then
                e.paddle.score = e.paddle.score + 1
            end
        end
    end
end

return ScoreSystem 