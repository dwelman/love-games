local Concord = require 'concord'

local PongGame = {
    world = nil,
    entities = nil
}

function PongGame:init()
    -- Load all components
    local components = love.filesystem.getDirectoryItems("games/pong/components")
    for _, file in ipairs(components) do
        if file:match("%.lua$") then
            local name = file:gsub("%.lua$", "")
            require("components." .. name)
        end
    end

    -- Load all systems
    local systems = {}
    local systemFiles = love.filesystem.getDirectoryItems("games/pong/systems")
    for _, file in ipairs(systemFiles) do
        if file:match("%.lua$") then
            local name = file:gsub("%.lua$", "")
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

    -- Create a sound entity to initialize the sound system
    local soundEntity = Concord.entity(self.world)
    soundEntity:give("sound")
    
    -- Load entities from configuration
    local entity_loader = require 'utils.entity_loader'
    self.entities = entity_loader.load_entities(self.world, "games/pong/pong.json")
end

function PongGame:update(dt)
    self.world:emit("update", dt)
end

function PongGame:draw()
    self.world:emit("draw")
end

function PongGame:keypressed(key)
    -- Emit keypressed event to all systems
    self.world:emit("keypressed", key)
end

function PongGame:quit()
    -- Save game state when quitting
    if self.entities then
        local entity_loader = require 'utils.entity_loader'
        entity_loader.save_entities(self.entities, "pong_save")
    end
end

return PongGame 