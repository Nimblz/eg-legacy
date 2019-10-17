local getPlayerState = require(script.Parent.getPlayerState)

return function(state,player, id)
    local pstate = getPlayerState(state,player)
    if pstate then
        return pstate.lastCollected[id]
    end
end