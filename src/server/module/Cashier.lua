local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local DevProducts = require(common:WaitForChild("DevProducts"))

local Cashier = PizzaAlpaca.GameModule:extend("Cashier")

function Cashier:promptPurchase(player,devproductId)
    local product = DevProducts.byId[devproductId]
    if product then
        MarketplaceService:PromptProductPurchase(player, product.productId)
    end
end

function Cashier:init()
    MarketplaceService.ProcessReceipt = function(recieptInfo)
        local player = Players:GetPlayerByUserId(recieptInfo.PlayerId)
        if not player then
            return Enum.ProductPurchaseDecision.NotProcessedYet
        end

        local productAssetId = recieptInfo.ProductId
        local product = DevProducts.byProductId[productAssetId]

        if product.onProductPurchase(player,self.core) then
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
    end
end

return Cashier