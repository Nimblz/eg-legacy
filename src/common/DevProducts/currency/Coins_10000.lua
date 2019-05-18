local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins10000",
    name = "10000 Coins",
    productId = 538435575,
    onSale = true,

    order = 3,

    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player,10000))
        return true -- Successful
    end)
}