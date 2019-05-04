local playerState = require(script.Parent:WaitForChild("playerState"))

return (function(state,action)
    state = state or {}

    if action.player then
        local playerKey = "player_"..action.player.UserId
        state[playerKey] = playerState(state[playerKey], action)
    end

    return state
end)