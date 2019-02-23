local reducerRoot = script.Parent

local coins = require(reducerRoot:WaitForChild("coins"))

return function(state,action)
    return {
        coins = coins(state.coins,action)
    }
end