local loader = {}

function loader.load_directory(directory)
    local items = {}
    local lfs = love.filesystem
    local files = lfs.getDirectoryItems(directory)
    
    for _, file in ipairs(files) do
        -- Only load .lua files
        if file:match("%.lua$") then
            local name = file:gsub("%.lua$", "")
            local path = directory .. '/' .. name
            items[name] = require(path)
        end
    end
    
    return items
end

function loader.load_components(directory)
    directory = directory or 'components'
    -- Components just need to be required, they register themselves
    for _, file in ipairs(love.filesystem.getDirectoryItems(directory)) do
        if file:match("%.lua$") then
            local name = file:gsub("%.lua$", "")
            require(directory .. '/' .. name)
        end
    end
end

function loader.load_systems(directory)
    directory = directory or 'systems'
    return loader.load_directory(directory)
end

return loader 