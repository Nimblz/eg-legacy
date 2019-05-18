local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local common = ReplicatedStorage:WaitForChild("common")

local by = require(common.util:WaitForChild("by"))
local products = require(common.util:WaitForChild("compileSubmodulesToArray"))(script, true)

for _,devproduct in pairs(products) do
    local productInfo = MarketplaceService:GetProductInfo(devproduct.productId, Enum.InfoType.Product)

	devproduct.price = productInfo.PriceInRobux
end

local function hasLowerOrder(asset1,asset2)
    return asset1.order < asset2.order
end

table.sort(products,hasLowerOrder)

return {
    all = products,
    byId = by("id", products),
    byProductId = by("productId", products)
}