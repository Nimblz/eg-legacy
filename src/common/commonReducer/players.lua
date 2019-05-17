local Players = game:GetService("Players")
local playerState = require(script.Parent:WaitForChild("playerState"))

return (function(state,action)
    state = state or {}

    if action.player then
        local newPlayerState = {}
        for _,player in pairs(Players:GetPlayers()) do
            local playerKey = "player_"..player.UserId
            newPlayerState[playerKey] = playerState(state[playerKey], action)
        end
        return newPlayerState
    end

    return state
end)