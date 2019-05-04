local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")
local commonReducer = common:WaitForChild("commonReducer")

local gameState = require(commonReducer)
local uiState = require(script:WaitForChild("uiState"))

return function(state,action)
    return {
        gameState = gameState(state.gameState,action),
        uiState = uiState(state.uiState,action),
    }
end