return function(player, assetId)
    return {
        type = script.Name,
        player = player,
        assetId = assetId,
        replicateTo = player,
    }
end