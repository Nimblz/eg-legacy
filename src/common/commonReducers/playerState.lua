local stats = require(script.Parent:WaitForChild("stats"))
local portals = require(script.Parent:WaitForChild("portals"))

return (function(state,action)
    state = state or {}
    local newState = {}

    -- server TODO: break this into two reducers?
    if action.type == "PLAYER_ADD" then -- load save data
        return action.saveData
    end

    if action.type == "PLAYER_REMOVE" then -- bye bye
        return nil
    end

    -- actual common stuff
    newState.stats = stats(state.stats,action)
    newState.portals = portals(state.portals,action)

    return newState
end)