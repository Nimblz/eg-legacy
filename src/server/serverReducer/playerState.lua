local stats = require(script.Parent:WaitForChild("stats"))

return (function(state,action)
    state = state or {}

    if action.type == "PLAYER_ADD" then
        return action.saveData
    end

    if action.type == "PLAYER_REMOVE" then
        return nil
    end

    state.stats = stats(state.stats,action)

    return state
end)