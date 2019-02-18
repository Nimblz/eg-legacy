local players = require(script.players)

return function(state,action)
    state = state or {}
    return {
        players = players(state.players,action)
    }
end