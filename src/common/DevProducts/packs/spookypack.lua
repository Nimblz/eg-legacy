local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Thunks = require(common:WaitForChild("Thunks"))

return {
    id = "itempack_spooky",
    name = "Spooky Item Pack",
    desc = (
        "Contains every halloween item!"
    ),
    productId = 838307012,
    color = Color3.fromRGB(230, 130, 0),
    onSale = true,

    order = 0,
    flavorText = "EVENT!",

    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
        end)
        return true -- Successful
    end)
}