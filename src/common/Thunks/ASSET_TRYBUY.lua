local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local ShopProducts = require(common:WaitForChild("ShopProducts"))

local Selectors = require(script.Parent.Parent:WaitForChild("Selectors"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))

return function(player,assetId)
    return function(store)
        local product = ShopProducts.byId[assetId]
        if product then
            if not Selectors.isOwned(store:getState(),player,assetId) then
                if Selectors.getCoins(store:getState(),player) >= product.price then
                    store:dispatch(Actions.COIN_SUBTRACT(player,product.price))
                    store:dispatch(Actions.ASSET_GIVE(player,assetId))
                end
            end
        end
    end
end