local stats = require(script.Parent:WaitForChild("stats"))
local portals = require(script.Parent:WaitForChild("portals"))
local inventory = require(script.Parent:WaitForChild("inventory"))
local equipped = require(script.Parent:WaitForChild("equipped"))

return (function(state,action)
    state = state or {}

    -- server TODO: break this into two reducers?
    if action.type == "PLAYER_ADD" then -- load save data
        state = action.saveData
    end

    if action.type == "PLAYER_REMOVE" then -- bye bye
        return nil
    end

    if action.type == "!!!CLEAR_SAVE!!!" then -- DANGER ZONE!
        state = {}
    end

    return {
        inventory = inventory(state.inventory, action),
        equipped = equipped(state.equipped, action),
        stats = stats(state.stats, action),
        portals = portals(state.portals, action),
    }
end)