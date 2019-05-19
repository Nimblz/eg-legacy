local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Selectors = require(common:WaitForChild("Selectors"))

-- function that returns true if a player has completed this objective
local function queryComplete(server,player,quantity)
    local state = server.store:getState()
    local coinCount = Selectors.getCoins(state,player) or 0

    return coinCount > quantity
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
        queryComplete = (function(server,player) return queryComplete(server,player,quantity) end),
    }
end