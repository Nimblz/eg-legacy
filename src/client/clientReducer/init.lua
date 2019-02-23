local reducerRoot = script

local stats = require(reducerRoot:WaitForChild("stats"))
local portals = require(reducerRoot:WaitForChild("portals"))

return function(state,action)
    state = state or {}
    return {
        portals = portals(state.portals,action),
        stats = stats(state.stats,action),
    }
end