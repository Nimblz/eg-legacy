local getPlayerState = require(script.Parent.getPlayerState)

return function(state, player)
    return getPlayerState(state,player).stats or {}
end