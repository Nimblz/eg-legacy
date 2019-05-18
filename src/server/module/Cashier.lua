local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local DevProducts = require(common:WaitForChild("DevProducts"))

local Cashier = {}

function Cashier:PromptPurchase(player,devproductId)
    local product = DevProducts.byId[devproductId]
    if product then
        MarketplaceService:PromptProductPurchase(player, product.productId)
    end
end

function Cashier:start(loader)
    MarketplaceService.ProcessReceipt = function(recieptInfo)
        local player = Players:GetPlayerByUserId(recieptInfo.PlayerId)
        if not player then
            return Enum.ProductPurchaseDecision.NotProcessedYet
        end

        local productAssetId = recieptInfo.ProductId
        local product = DevProducts.byProductId[productAssetId]

        if product.onProductPurchase(player,loader) then
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
    end
end

return Cashier