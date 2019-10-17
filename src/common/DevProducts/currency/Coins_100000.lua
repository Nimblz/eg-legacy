local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins100000",
    name = "100000 Coins",
    desc = (
        "Gives 100,000 coins."
    ),
    productId = 838298609,
    onSale = true,

    order = 13,

    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Actions.COIN_ADD(player,100000))
        end)
        return true -- Successful
    end)
}