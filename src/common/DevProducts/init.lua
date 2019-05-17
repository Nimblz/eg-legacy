local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local common = ReplicatedStorage:WaitForChild("common")

local by = require(common.util:WaitForChild("by"))
local products = require(common.util:WaitForChild("compileSubmodulesToArray"))(script, true)

local function isLessExpensive(asset1,asset2)
    local asset1Info = MarketplaceService:GetProductInfo(asset1.productId, Enum.InfoType.Product)
    local asset2Info = MarketplaceService:GetProductInfo(asset2.productId, Enum.InfoType.Product)

    return asset1Info.PriceInRobux < asset2Info.PriceInRobux
end

table.sort(products,isLessExpensive)

return {
    all = products,
    byId = by("id", products),
}