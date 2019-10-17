local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

return {
    id = "candy2000",
    name = "2k Candy",
    productId = 838308170,
    color = Color3.fromRGB(230, 130, 0),
    onSale = true,

    order = 1,
    flavorText = "EVENT!",


    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Actions.CANDY_ADD(player,2000))
        end)
        return true -- Successful
    end)
}