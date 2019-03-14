local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")
local commonReducers = common:WaitForChild("commonReducers")

local playerState = require(commonReducers:WaitForChild("playerState"))

return (function(state,action)
    state = state or {}

    if action.player then
        state[action.player] = playerState(state[action.player], action)
    end

    return state
end)