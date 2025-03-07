local Concord = require 'concord'

local SoundSystem = Concord.system({
    pool = {"sound"}
})

function SoundSystem:init(world)
    self.world = world
    self.sounds = {}
    
    -- Load all sound files from the assets/sounds directory
    self:loadSounds()
    
    print("Sound system initialized with " .. self:countSounds() .. " sounds")
end

function SoundSystem:countSounds()
    local count = 0
    for _ in pairs(self.sounds) do
        count = count + 1
    end
    return count
end

function SoundSystem:loadSounds()
    -- Get the base path for the current game's sound assets
    local basePath = "games/pong/assets/sounds/"
    
    -- Check if the directory exists
    local success = love.filesystem.getInfo(basePath, "directory")
    if not success then
        print("Warning: Sound directory not found at " .. basePath)
        return
    end
    
    -- Load all sound files in the directory
    local files = love.filesystem.getDirectoryItems(basePath)
    for _, file in ipairs(files) do
        -- Skip README and text files
        if file:match("%.md$") or file:match("%.txt$") then
            goto continue
        end
        
        local filePath = basePath .. file
        -- Check if the file exists and has a supported audio extension
        local supportedExtensions = {".wav", ".mp3", ".ogg", ".flac"}
        local hasValidExtension = false
        local extension = file:match("%.%w+$")
        
        if extension then
            for _, ext in ipairs(supportedExtensions) do
                if extension:lower() == ext then
                    hasValidExtension = true
                    break
                end
            end
        end
        
        if love.filesystem.getInfo(filePath, "file") and hasValidExtension then
            print("Loading sound: " .. filePath)
            local success, source = pcall(function()
                return love.audio.newSource(filePath, "static")
            end)
            
            if success then
                local soundName = file:gsub("%.%w+$", "") -- Remove file extension
                self.sounds[soundName] = source
                print("Loaded sound: " .. soundName .. " from " .. filePath)
            else
                print("Failed to load sound: " .. filePath .. " - " .. tostring(source))
            end
        end
        
        ::continue::
    end
    
    -- Also load the pong.mp3 file if it exists in the parent directory
    local pongFilePath = "games/pong/assets/pong.mp3"
    if love.filesystem.getInfo(pongFilePath, "file") then
        local success, source = pcall(function()
            return love.audio.newSource(pongFilePath, "static")
        end)
        
        if success then
            self.sounds["pong"] = source
            print("Loaded sound: pong from " .. pongFilePath)
        else
            print("Failed to load sound: " .. pongFilePath .. " - " .. tostring(source))
        end
    end
    
    -- If no sounds were loaded, print a warning
    if next(self.sounds) == nil then
        print("Warning: No sound files were loaded")
    end
end

function SoundSystem:playSound(name, pitch, volume)
    local sound = self.sounds[name]
    if not sound then
        print("Warning: Sound not found: " .. name)
        return
    end
    
    -- Create a clone of the source to allow multiple instances to play simultaneously
    local success, clone = pcall(function()
        return sound:clone()
    end)
    
    if not success then
        print("Failed to clone sound: " .. name .. " - " .. tostring(clone))
        return
    end
    
    -- Set pitch and volume if provided
    if pitch then
        clone:setPitch(pitch)
    end
    
    if volume then
        clone:setVolume(volume)
    end
    
    -- Play the sound
    local success, err = pcall(function()
        clone:play()
    end)
    
    if success then
        print("Playing sound: " .. name .. (pitch and " with pitch " .. pitch or ""))
    else
        print("Failed to play sound: " .. name .. " - " .. tostring(err))
    end
end

-- Handle paddle hit event
function SoundSystem:paddleHit(ball)
    -- Calculate pitch based on ball speed
    local speed = math.sqrt(ball.movement.dx^2 + ball.movement.dy^2)
    local basePitch = 1.0
    local maxPitch = 2.0
    local minSpeed = 200  -- Approximate base speed
    local maxSpeed = 600  -- Approximate max speed after several hits
    
    -- Calculate pitch between 1.0 and 2.0 based on speed
    local pitch = basePitch + (speed - minSpeed) / (maxSpeed - minSpeed) * (maxPitch - basePitch)
    pitch = math.max(basePitch, math.min(maxPitch, pitch))
    
    -- Try to play paddle_hit sound first, fall back to pong
    if self.sounds["paddle_hit"] then
        self:playSound("paddle_hit", pitch)
    elseif self.sounds["pong"] then
        self:playSound("pong", pitch)
    else
        print("Warning: No sound available for paddle hit")
    end
end

-- Handle wall hit event
function SoundSystem:wallHit()
    -- Try to play paddle_hit sound first with lower pitch, fall back to pong
    if self.sounds["paddle_hit"] then
        self:playSound("paddle_hit", 0.8)
    elseif self.sounds["pong"] then
        self:playSound("pong", 0.8)
    else
        print("Warning: No sound available for wall hit")
    end
end

-- Handle score event
function SoundSystem:scoreSound()
    -- Try to play score sound first, fall back to pong with lower pitch
    if self.sounds["score"] then
        self:playSound("score")
    elseif self.sounds["pong"] then
        self:playSound("pong", 0.5)
    else
        print("Warning: No sound available for score")
    end
end

return SoundSystem 