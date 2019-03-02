local playerState = require(script.Parent:WaitForChild("playerState"))

return (function(state,action)
    state = state or {}

    if action.player then
        state[action.player] = playerState(state[action.player], action)
    end

    return state
end)