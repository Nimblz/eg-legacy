local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "coins999999999999",
    name = "999999999999 Coins",
    productId = 539532548,
    onSale = true,

    order = 7,

    onProductPurchase = (function(player, server)
        local store = server.store
        store:dispatch(Actions.COIN_ADD(player, 999999999999))
        return true -- Successful
    end)
}