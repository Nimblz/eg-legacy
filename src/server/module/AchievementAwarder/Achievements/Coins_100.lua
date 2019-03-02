-- function that returns true if a player has completed this objective
local function queryComplete(server,player)
    local state = server.store:getState()
    local playerState = state.players[player]
    if playerState then
        local coinCount = (playerState.stats or {}).coins or 0

        if coinCount >= 100 then
            return true
        end
    end
    return false
end

return {
    id = script.Name,
    name = "100 Coins",
    desc = "Obtain 100 coins.",
    badgeId = 0,
    startListening = (function(server, awardBadge)
        local coins = server:getModule("Coins")

        coins.coinCollected:connect(function(player,newCount)
            if queryComplete(server, player) then
                awardBadge(player)
            end
        end)
    end),
    queryComplete = queryComplete,
    onAward = (function(server,player)
        print("your winner!")
    end)
}