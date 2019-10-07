local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Thunks = require(common:WaitForChild("Thunks"))

return {
    id = "itempack_rainbow",
    name = "Rainbow Item Pack",
    productId = 545309170,
    onSale = true,

    order = 0,
    flavorText = "SALE!",

    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"material_rainbow"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_rainbowsquid"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_rainbowbunny"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"rainbowcrown"))
        end)
        return true -- Successful
    end)
}