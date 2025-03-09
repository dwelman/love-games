local Concord = require 'concord'

Concord.component("asteroid", function(component, size)
    component.size = size or "large"  -- Size of the asteroid: "large", "medium", or "small"
end) 