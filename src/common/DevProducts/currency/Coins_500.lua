local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins500",
    name = "500 Coins",
    productId = 538434691,
    onSale = true,

    order = 1,
    
    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player,500))
        return true -- Successful
    end)
} 