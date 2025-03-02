local Concord = require 'concord'

local RenderSystem = Concord.system({
    entities = {"position", "size"}
})

function RenderSystem:draw()
    -- Draw center line
    love.graphics.setColor(0.5, 0.5, 0.5)
    for y = 0, 600, 30 do
        love.graphics.rectangle("fill", 395, y, 10, 15)
    end
    
    -- Draw entities
    love.graphics.setColor(1, 1, 1)
    for _, e in ipairs(self.entities) do
        love.graphics.rectangle("fill", e.position.x, e.position.y, e.size.w, e.size.h)
    end
    
    -- Draw scores
    local leftScore, rightScore = 0, 0
    for _, e in ipairs(self.entities) do
        if e.paddle then
            if e.position.x < 400 then
                leftScore = e.paddle.score
            else
                rightScore = e.paddle.score
            end
        end
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(tostring(leftScore), 350, 50, 0, 2, 2)
    love.graphics.print(tostring(rightScore), 430, 50, 0, 2, 2)
end

return RenderSystem 