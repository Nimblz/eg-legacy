local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")

local Assets = require(common:WaitForChild("Assets"))

local by = require(common.util:WaitForChild("by"))
local products = require(common.util:WaitForChild("compileSubmodulesToArray"))(script, true)
local rawProductsById = by("id", products)
-- Compile basic assets based on rarity
local basicAssets = Assets.basic

-- generic price table for basic assets
local priceTable = {
    [1] = 50,
    [2] = 150,
    [3] = 500,
    [4] = 5000,
    [5] = 10000,
    [6] = 20000,
}

for id, asset in pairs(basicAssets) do
    local newProduct = {
        id = id,
        price = priceTable[asset.rarity or 1],
        onSale = true,
    }
    if not rawProductsById[id] then
        table.insert(products,newProduct)
    end
end

local function isLessExpensive(asset1,asset2)
    return asset1.price < asset2.price
end

table.sort(products,isLessExpensive)

return {
    all = products,
    byId = by("id", products),
}