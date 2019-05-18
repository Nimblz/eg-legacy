local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins150000",
    name = "150k Coins",
    productId = 538436032,
    onSale = true,

    order = 5,


    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player,150000))
        return true -- Successful
    end)
}