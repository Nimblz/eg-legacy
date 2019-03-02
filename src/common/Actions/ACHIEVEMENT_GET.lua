return function(player, achievementId)
    return {
        type = script.Name,
        player = player,
        achievementId = achievementId,
        replicateTo = player,
    }
end