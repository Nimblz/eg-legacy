local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins1000000",
    name = "1M Coins",
    desc = (
        "Gives 1,000,000 coins."
    ),
    productId = 838293310,
    onSale = true,

    order = 14,
    flavorText = "Best deal!",


    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Actions.COIN_ADD(player,1000000))
        end)
        return true -- Successful
    end)
}