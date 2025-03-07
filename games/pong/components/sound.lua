local Concord = require 'concord'

Concord.component("sound", function(component, sources)
    component.sources = sources or {}  -- Table to store loaded sound sources
    component.volume = 1.0            -- Default volume
end) 