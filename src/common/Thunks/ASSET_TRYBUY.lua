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
            print("product exists")
            if not Selectors.isOwned(store:getState(),player,assetId) then
                print("not owned trying to buy")
                if Selectors.getCoins(store:getState(),player) >= product.price then
                    print("bought")
                    store:dispatch(Actions.COIN_SUBTRACT(player,product.price))
                    store:dispatch(Actions.ASSET_GIVE(player,assetId))
                end
            end
        end
    end
end