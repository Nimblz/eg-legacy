local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins2500",
    name = "2500 Coins",
    productId = 538435372,
    onSale = true,

    order = 2,

    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player,2500))
        return true -- Successful
    end)
}