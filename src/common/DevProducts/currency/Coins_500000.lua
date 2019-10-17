local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins500000",
    name = "500k Coins",
    desc = (
        "Gives 500,000 coins."
    ),
    productId = 838295492,
    onSale = true,

    order = 14,

    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Actions.COIN_ADD(player,500000))
        end)
        return true -- Successful
    end)
}