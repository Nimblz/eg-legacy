return function(state,player,assetId)
    return state.players[player].inventory[assetId] == true
end