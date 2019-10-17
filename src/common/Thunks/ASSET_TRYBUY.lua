local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local ShopProducts = require(common:WaitForChild("ShopProducts"))

local Selectors = require(script.Parent.Parent:WaitForChild("Selectors"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))

local currencyActions = {
    coins = Actions.COIN_SUBTRACT,
    candy = Actions.CANDY_SUBTRACT,
}

return function(player,assetId)
    return function(store)
        local product = ShopProducts.byId[assetId]
        if product then
            local currencyType = product.currency or "coins"
            if not Selectors.isOwned(store:getState(),player,assetId) then
                local stats = Selectors.getStats(store:getState(),player)
                local ownedCurrency = stats[currencyType] or 0
                if ownedCurrency >= product.price then
                    store:dispatch(currencyActions[currencyType](player,product.price))
                    store:dispatch(Actions.ASSET_GIVE(player,assetId))
                end
            end
        end
    end
end