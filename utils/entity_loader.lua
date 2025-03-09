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
    
    -- Debug output
    print("Loading entities from: " .. config_path)
    
    -- Handle both array and object formats for entities
    if config.entities and type(config.entities) == "table" then
        if #config.entities > 0 then
            -- Array format (used by Asteroids)
            print("Found " .. #config.entities .. " entities in config (array format)")
            
            for i, entity_config in ipairs(config.entities) do
                local entity_name = entity_config.name or ("entity_" .. i)
                print("Creating entity: " .. entity_name)
                
                local entity = Concord.entity(world)
                
                -- Add components based on configuration
                for component_name, component_data in pairs(entity_config.components) do
                    print("  Adding component: " .. component_name)
                    
                    if component_name == "position" then
                        entity:give(component_name, component_data.x, component_data.y)
                    elseif component_name == "rotation" then
                        entity:give(component_name, component_data.angle)
                    elseif component_name == "velocity" then
                        entity:give(component_name, component_data.dx, component_data.dy, component_data.drag)
                    elseif component_name == "player" then
                        entity:give(component_name, component_data.rotationSpeed, component_data.thrustPower, component_data.maxSpeed)
                    elseif component_name == "vector" then
                        entity:give(component_name, component_data.shape, component_data.scale, component_data.color)
                    elseif component_name == "collider" then
                        entity:give(component_name, component_data.radius)
                    elseif component_name == "asteroid" then
                        entity:give(component_name, component_data.size)
                    elseif component_name == "rotator" then
                        entity:give(component_name, component_data.speed)
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
        else
            -- Object format (used by Pong)
            print("Found " .. table.count(config.entities) .. " entities in config (object format)")
            
            for entity_name, entity_config in pairs(config.entities) do
                print("Creating entity: " .. entity_name)
                
                local entity = Concord.entity(world)
                
                -- Add components based on configuration
                for component_name, component_data in pairs(entity_config.components) do
                    print("  Adding component: " .. component_name)
                    
                    if component_name == "position" then
                        entity:give(component_name, component_data.x, component_data.y)
                    elseif component_name == "rotation" then
                        entity:give(component_name, component_data.angle)
                    elseif component_name == "velocity" then
                        entity:give(component_name, component_data.dx, component_data.dy, component_data.drag)
                    elseif component_name == "player" then
                        entity:give(component_name, component_data.rotationSpeed, component_data.thrustPower, component_data.maxSpeed)
                    elseif component_name == "vector" then
                        entity:give(component_name, component_data.shape, component_data.scale, component_data.color)
                    elseif component_name == "collider" then
                        entity:give(component_name, component_data.radius)
                    elseif component_name == "asteroid" then
                        entity:give(component_name, component_data.size)
                    elseif component_name == "rotator" then
                        entity:give(component_name, component_data.speed)
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
        end
    else
        print("No entities found in config")
    end
    
    return entities
end

-- Helper function to count table entries
function table.count(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function entity_loader.save_entities(entities, filename)
    local config = {entities = {}}
    
    for entity_name, entity in pairs(entities) do
        config.entities[entity_name] = {components = {}}
        local components = config.entities[entity_name].components
        
        if entity.position then
            components.position = {x = entity.position.x, y = entity.position.y}
        end
        
        if entity.rotation then
            components.rotation = {angle = entity.rotation.angle}
        end
        
        if entity.velocity then
            components.velocity = {dx = entity.velocity.dx, dy = entity.velocity.dy, drag = entity.velocity.drag}
        end
        
        if entity.player then
            components.player = {
                rotationSpeed = entity.player.rotationSpeed,
                thrustPower = entity.player.thrustPower,
                maxSpeed = entity.player.maxSpeed,
                lives = entity.player.lives
            }
        end
        
        if entity.vector then
            components.vector = {
                shape = entity.vector.shape,
                scale = entity.vector.scale,
                color = entity.vector.color,
                lineWidth = entity.vector.lineWidth,
                closed = entity.vector.closed
            }
        end
        
        if entity.collider then
            components.collider = {radius = entity.collider.radius}
        end
        
        if entity.asteroid then
            components.asteroid = {size = entity.asteroid.size}
        end
        
        if entity.rotator then
            components.rotator = {speed = entity.rotator.speed}
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