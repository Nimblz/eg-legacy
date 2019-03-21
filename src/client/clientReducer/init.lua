local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")
local commonReducers = common:WaitForChild("commonReducers")

local playerState = require(commonReducers:WaitForChild("playerState"))
local uiState = require(script:WaitForChild("uiState"))

return function(state,action)
    return {
        playerState = playerState(state.playerState,action),
        uiState = uiState(state.uiState,action),
    }
end