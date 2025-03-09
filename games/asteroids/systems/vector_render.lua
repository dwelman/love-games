local Concord = require 'concord'

-- Define vector shapes for different entities
local VectorShapes = {
    -- Player ship shape (triangle pointing upward)
    ship = {
        {0, -10},   -- Nose
        {-7, 10},   -- Left corner
        {0, 5},     -- Bottom middle
        {7, 10}     -- Right corner
    },
    
    -- Thruster flame
    thruster = {
        {0, 7},     -- Top
        {-5, 15},   -- Left
        {0, 12},    -- Middle
        {5, 15}     -- Right
    },
    
    -- Bullet shape (small line)
    bullet = {
        {0, -3},
        {0, 3}
    },
    
    -- Large asteroid shape (irregular polygon)
    asteroid_large = {
        {-30, 0},
        {-15, -25},
        {15, -30},
        {30, -15},
        {20, 20},
        {0, 30},
        {-20, 15}
    },
    
    -- Medium asteroid shape
    asteroid_medium = {
        {-20, 0},
        {-10, -15},
        {10, -20},
        {20, -5},
        {15, 15},
        {0, 20},
        {-15, 10}
    },
    
    -- Small asteroid shape
    asteroid_small = {
        {-10, 0},
        {-5, -8},
        {5, -10},
        {10, -3},
        {8, 8},
        {0, 10},
        {-8, 5}
    }
}

local VectorRenderSystem = Concord.system({
    pool = {"position", "rotation", "vector"}
})

function VectorRenderSystem:init(world)
    self.world = world
    self.debugInitialized = false
    self.debugEnabled = false
    
    -- Find debug system if it exists
    if world.__systems then
        for _, system in ipairs(world.__systems) do
            if system.isDebugEnabled then
                self.debugSystem = system
                self.debugEnabled = system:isDebugEnabled()
                break
            end
        end
    end
end

function VectorRenderSystem:update(dt)
    -- Debug output to check entities in the pool
    if not self.debugInitialized then
        print("Vector Render System initialized")
        self.debugInitialized = true
    end
    
    -- Update debug state if debug system exists
    if self.debugSystem then
        self.debugEnabled = self.debugSystem:isDebugEnabled()
    end
    
    -- Count entities by type for debugging
    if self.debugEnabled and love.timer.getTime() < 2 then
        local shipCount = 0
        local bulletCount = 0
        local asteroidCount = 0
        
        for _, entity in ipairs(self.pool) do
            if entity.vector.shape == "ship" then
                shipCount = shipCount + 1
            elseif entity.vector.shape == "bullet" then
                bulletCount = bulletCount + 1
            elseif entity.vector.shape:find("asteroid") then
                asteroidCount = asteroidCount + 1
            end
        end
        
        print("Entities in render pool: " .. #self.pool .. 
              " (Ships: " .. shipCount .. 
              ", Bullets: " .. bulletCount .. 
              ", Asteroids: " .. asteroidCount .. ")")
    end
end

function VectorRenderSystem:debugStateChanged(isEnabled)
    self.debugEnabled = isEnabled
end

function VectorRenderSystem:draw()
    love.graphics.setLineStyle("smooth")
    
    for _, entity in ipairs(self.pool) do
        local position = entity.position
        local rotation = entity.rotation
        local vector = entity.vector
        
        -- Get the shape points
        local shape = VectorShapes[vector.shape]
        if not shape then
            print("Warning: Shape not found: " .. vector.shape)
            goto continue
        end
        
        -- Set color and line width
        love.graphics.setColor(vector.color)
        love.graphics.setLineWidth(vector.lineWidth)
        
        -- Save the current transformation state
        love.graphics.push()
        
        -- Apply transformations
        love.graphics.translate(position.x, position.y)
        love.graphics.rotate(rotation.angle)
        love.graphics.scale(vector.scale, vector.scale)
        
        -- Draw the shape
        if #shape >= 2 then
            if vector.closed and #shape > 2 then
                -- Draw closed shape
                love.graphics.polygon("line", self:flattenPoints(shape))
            else
                -- Draw open shape (line)
                love.graphics.line(self:flattenPoints(shape))
            end
        end
        
        -- Draw thruster if this is the player and thrusting
        if vector.shape == "ship" and entity.player and entity.player.thrusting then
            love.graphics.setColor(1, 0.5, 0, 0.8) -- Orange flame
            local thruster = VectorShapes["thruster"]
            love.graphics.line(self:flattenPoints(thruster))
        end
        
        -- Restore the transformation state
        love.graphics.pop()
        
        -- Draw collision circle only when debug mode is enabled
        if self.debugEnabled and entity.collider then
            love.graphics.setColor(1, 0, 0, 0.3)
            love.graphics.circle("line", position.x, position.y, entity.collider.radius)
        end
        
        ::continue::
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

-- Helper function to flatten a table of points for love.graphics functions
function VectorRenderSystem:flattenPoints(points)
    local flattened = {}
    for i, point in ipairs(points) do
        flattened[2*i-1] = point[1]
        flattened[2*i] = point[2]
    end
    return flattened
end

return VectorRenderSystem 