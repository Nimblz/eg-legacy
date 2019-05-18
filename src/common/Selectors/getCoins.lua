local getStats = require(script.Parent.getStats)

return function(state, player)
    return getStats(state,player).coins or 0
end