-- function that returns true if a player has completed this objective
local function queryComplete(server,player,quantity)
    local state = server.store:getState()
    local playerState = state.players[player]
    if playerState then
        local coinCount = (playerState.stats or {}).coins or 0

        if coinCount >= quantity then
            return true
        end
    end
    return false
end

return function(quantity,badgeId)
    return {
        id = "Coins_"..quantity,
        name = quantity.." Coins",
        desc = "Obtain "..quantity.." coins.",
        badgeId = badgeId,
        startListening = (function(server, awardBadge)
            local coins = server:getModule("Coins")

            coins.coinCollected:connect(function(player,newCount)
                if queryComplete(server, player, quantity) then
                    awardBadge(player)
                end
            end)
        end),
        queryComplete = (function(server,player) queryComplete(server,player,quantity) end),
        onAward = (function(server,player)
            print("your winner!")
        end)
    }
end