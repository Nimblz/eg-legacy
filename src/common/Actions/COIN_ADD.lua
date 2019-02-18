return function(player, coins)
    assert(typeof(player)=="instance" and player:IsA("Player"), "expected type Player in arg 1") -- i should really be using t
    assert(type(coins)=="number", "expected type Number in arg 2")

    return {
        type = script.Name,
        player = player,
        coins = coins,
    }
end