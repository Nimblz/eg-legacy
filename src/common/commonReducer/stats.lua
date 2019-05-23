local coins = require(script.Parent:WaitForChild("coins"))
local achievements = require(script.Parent:WaitForChild("achievements"))
local lastlogin = require(script.Parent:WaitForChild("lastlogin"))
local totalCoinsCollected = require(script.Parent:WaitForChild("totalCoinsCollected"))

return (function(state,action)
    state = state or {}

    return {
        coins = coins(state.coins,action),
        totalCoinsCollected = totalCoinsCollected(state.totalCoinsCollected, action),
        achievements = achievements(state.achievements,action),
        coinCollectionRange = 5,
        lastlogin = lastlogin(state.lastlogin,action),
        walkspeed = 16;
        sprintModifier = 1.5;
        airJumps = 0;
        dashes = 0;
        canFly = false;
        canSwim = false;
        canWaterWalk = false;
        canRoll = false;
        noSlip = false;
    }
end)