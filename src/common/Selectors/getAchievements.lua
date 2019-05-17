local getStats = require(script.Parent.getStats)

return function(state,player)
    return getStats(state,player).achievements or {}
end