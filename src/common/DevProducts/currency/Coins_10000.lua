local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins10000",
    name = "10000 Coins",
    desc = (
        "Gives 10,000 coins."
    ),
    productId = 838301984,
    onSale = true,

    order = 11,

    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Actions.COIN_ADD(player,10000))
        end)
        return true -- Successful
    end)
}