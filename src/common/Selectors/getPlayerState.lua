return function(state, player)
    local playerKey = "player_"..player.UserId
    if not state.players then return end
    return state.players[playerKey]
end