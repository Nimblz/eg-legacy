local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Thunks = require(common:WaitForChild("Thunks"))

return {
    id = "itempack_rainbow",
    name = "Rainbow Item Pack",
    desc = (
        "Contains every rainbow item.\n"..
        "List of contents:\n"..
        "  *  PET: Rainbow Scoobis\n"..
        "  *  PET: Rainbow Bunny\n"..
        "  *  PET: Rainbow Squid\n"..
        "  *  PET: Rainbow Seal\n"..
        "  *  PET: Rainbow Bastet\n"..
        "  *  HAT: Black Domino Crown\n"..
        "  *  HAT: Omega Horns of Timeless Oblivion\n"..
        "  *  MATERIAL: Rainbow\n"
    ),
    productId = 545309170,
    onSale = true,

    order = 3,

    onProductPurchase = (function(player, server)
        server:getModule("StoreContainer"):getStore():andThen(function(store)
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"material_rainbow"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_rainbowsquid"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_rainbowbunny"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_rainbowscoob"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_rainbowseal"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_rainbowbastet"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"blackdomino"))
            store:dispatch(Thunks.ASSET_TRYGIVE(player,"omegahorns"))
        end)
        return true -- Successful
    end)
}