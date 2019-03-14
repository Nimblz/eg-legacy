local coins = require(script.Parent:WaitForChild("coins"))
local achievements = require(script.Parent:WaitForChild("achievements"))

return (function(state,action)
    state = state or {}

    return {
        coins = coins(state.coins,action),
        achievements = achievements(state.achievements,action),
        coinCollectionRange = 5,
    }
end)