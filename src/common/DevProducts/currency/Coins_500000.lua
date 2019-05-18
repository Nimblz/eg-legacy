local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins500000",
    name = "500k Coins",
    productId = 538436531,
    onSale = true,

    order = 6,

    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player, 500000))
        return true -- Successful
    end)
}