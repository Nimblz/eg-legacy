return function(state, player)
    local playerKey = "player_"..player.UserId
    return state.players[playerKey] or {}
end