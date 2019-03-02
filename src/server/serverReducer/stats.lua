local coins = require(script.Parent:WaitForChild("coins"))
local achievements = require(script.Parent:WaitForChild("achievements"))

return (function(state,action)
    state = state or {}

    state.coins = coins(state.coins,action)
    state.achievements = achievements(state.achievements,action)

    return state
end)