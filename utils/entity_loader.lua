local Concord = require 'concord'
local json = require 'utils.json'
local entity_loader = {}

function entity_loader.load_entities(world, config_path)
    local entities = {}
    local config_contents = love.filesystem.read(config_path)
    
    if not config_contents then
        error("Could not load entity config file: " .. config_path)
    end
    
    local config = json.decode(config_contents)
    
    for entity_name, entity_config in pairs(config.entities) do
        local entity = Concord.entity(world)
        
        -- Add components based on configuration
        for component_name, component_data in pairs(entity_config.components) do
            if component_name == "position" then
                entity:give(component_name, component_data.x, component_data.y)
            elseif component_name == "movement" then
                entity:give(component_name, component_data.speed)
            elseif component_name == "size" then
                entity:give(component_name, component_data.w, component_data.h)
            elseif component_name == "paddle" then
                entity:give(component_name, component_data.isAI)
            else
                entity:give(component_name)
            end
        end
        
        entities[entity_name] = entity
    end
    
    return entities
end

function entity_loader.save_entities(entities, filename)
    local config = {entities = {}}
    
    for entity_name, entity in pairs(entities) do
        config.entities[entity_name] = {components = {}}
        local components = config.entities[entity_name].components
        
        if entity.position then
            components.position = {x = entity.position.x, y = entity.position.y}
        end
        
        if entity.movement then
            components.movement = {speed = entity.movement.speed}
        end
        
        if entity.size then
            components.size = {w = entity.size.w, h = entity.size.h}
        end
        
        if entity.paddle then
            components.paddle = {isAI = entity.paddle.isAI}
        end
        
        if entity.ball then
            components.ball = {}
        end
    end
    
    local json_str = json.encode(config)
    love.filesystem.write('entities/' .. filename .. '.json', json_str)
end

return entity_loader 