local reducerRoot = script.Parent

local stats = require(reducerRoot:WaitForChild("stats"))

return function(state,action)
    return {
        stats = stats(state.stats,action)
    }
end