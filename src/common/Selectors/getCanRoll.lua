local getStats = require(script.Parent.getStats)

return function(state, player)
    local pstats = getStats(state,player)
    if pstats then
        return getStats(state,player).canRoll
    end
end