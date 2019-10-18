local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Thunks = require(common:WaitForChild("Thunks"))

local Assets = require(common:WaitForChild("Assets"))

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
            local allProducts = Assets.all

            for _,product in pairs(allProducts) do
                if product.shopCatagory == "halloween" then
                    store:dispatch(Thunks.ASSET_TRYGIVE(player, product.id))
                end
            end
        end)
        return true -- Successful
    end)
}