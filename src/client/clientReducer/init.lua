local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")
local commonReducer = common:WaitForChild("commonReducer")

local Dictionary = require(common:WaitForChild("Dictionary"))

local gameState = require(commonReducer)
local uiState = require(script:WaitForChild("uiState"))

return function(state,action)
    state = state or {}
    return Dictionary.join(
        gameState(state,action),
        uiState(state,action)
    )
end