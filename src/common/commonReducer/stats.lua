local coins = require(script.Parent:WaitForChild("coins"))
local achievements = require(script.Parent:WaitForChild("achievements"))
local lastlogin = require(script.Parent:WaitForChild("lastlogin"))

return (function(state,action)
    state = state or {}

    return {
        coins = coins(state.coins,action),
        achievements = achievements(state.achievements,action),
        coinCollectionRange = 5,
        lastlogin = lastlogin(state.lastlogin,action),
    }
end)