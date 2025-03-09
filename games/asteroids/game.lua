local Concord = require 'concord'

local AsteroidsGame = {
    world = nil,
    entities = nil
}

function AsteroidsGame:init()
    print("Initializing Asteroids Game")
    
    -- Load all components
    local components = love.filesystem.getDirectoryItems("games/asteroids/components")
    for _, file in ipairs(components) do
        if file:match("%.lua$") then
            local name = file:gsub("%.lua$", "")
            print("Loading component: " .. name)
            require("components." .. name)
        end
    end

    -- Load all systems
    local systems = {}
    local systemFiles = love.filesystem.getDirectoryItems("games/asteroids/systems")
    for _, file in ipairs(systemFiles) do
        if file:match("%.lua$") then
            local name = file:gsub("%.lua$", "")
            print("Loading system: " .. name)
            systems[name] = require("systems." .. name)
        end
    end

    -- Create game world
    self.world = Concord.world()
    
    -- Store reference to the game in the world
    self.world.game = self

    -- Initialize all systems
    for name, system in pairs(systems) do
        print("Adding system: " .. name)
        self.world:addSystem(system, self.world)
    end

    -- Load entities from configuration
    local entity_loader = require 'utils.entity_loader'
    print("Loading entities from configuration")
    self.entities = entity_loader.load_entities(self.world, "games/asteroids/asteroids.json")
    
    -- Debug: Check if player entity was created
    local playerFound = false
    for _, entity in ipairs(self.world:getEntities()) do
        if entity.player then
            playerFound = true
            print("Player entity found")
            break
        end
    end
    
    if not playerFound then
        print("WARNING: Player entity not found in loaded entities. Creating manually.")
        self:createPlayerShip()
    end
    
    -- Initialize asteroid field
    print("Creating initial asteroids")
    self:initAsteroids(3) -- Start with 3 large asteroids
end

function AsteroidsGame:createPlayerShip()
    -- Create player ship manually if it wasn't loaded from config
    local player = Concord.entity(self.world)
    player:give("position", 400, 300)
    player:give("rotation", 0)
    player:give("velocity", 0, 0, 0.98)
    player:give("player", 3.5, 200, 300)
    player:give("vector", "ship", 1.0, {1, 1, 1, 1})
    player:give("collider", 15)
    
    print("Player ship created manually")
    return player
end

function AsteroidsGame:initAsteroids(count)
    -- Create initial asteroids
    for i = 1, count do
        -- Position asteroids away from the player
        local x, y
        repeat
            x = math.random(50, 750)
            y = math.random(50, 550)
        until math.sqrt((x - 400)^2 + (y - 300)^2) > 150
        
        -- Random velocity
        local angle = math.random() * math.pi * 2
        local speed = math.random(20, 50)
        local dx = math.cos(angle) * speed
        local dy = math.sin(angle) * speed
        
        -- Create asteroid entity
        local asteroid = Concord.entity(self.world)
        asteroid:give("position", x, y)
        asteroid:give("rotation", math.random() * math.pi * 2)
        asteroid:give("velocity", dx, dy, 1.0) -- No drag for asteroids
        asteroid:give("asteroid", "large")
        asteroid:give("vector", "asteroid_large", math.random(0.8, 1.2), {1, 1, 1, 1})
        asteroid:give("collider", 40)
        asteroid:give("rotator", math.random(-1, 1) * math.random(0.5, 1.5))
    end
    
    print("Created " .. count .. " asteroids")
end

function AsteroidsGame:update(dt)
    self.world:emit("update", dt)
end

function AsteroidsGame:draw()
    self.world:emit("draw")
end

function AsteroidsGame:keypressed(key)
    -- Emit keypressed event to all systems
    self.world:emit("keypressed", key)
end

function AsteroidsGame:quit()
    -- Save game state when quitting
    if self.entities then
        local entity_loader = require 'utils.entity_loader'
        entity_loader.save_entities(self.entities, "asteroids_save")
    end
end

return AsteroidsGame 