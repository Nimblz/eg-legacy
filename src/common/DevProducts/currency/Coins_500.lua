local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins500",
    name = "500 Coins",
    productId = 538434691,
    onSale = true,

    order = 11,

    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Actions.COIN_ADD(player,500))
        end)
        return true -- Successful
    end)
}