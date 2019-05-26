local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins300000",
    name = "300k Coins",
    productId = 538436032,
    onSale = true,

    order = 15,


    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player,300000))
        return true -- Successful
    end)
}