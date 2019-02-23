return function(player, coins)
    return {
        type = script.Name,
        player = player,
        coins = coins,
        replicatesTo = player,
    }
end