local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins50000",
    name = "50000 Coins",
    productId = 538435748,
    onSale = true,

    order = 14,

    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player,50000))
        return true -- Successful
    end)
}