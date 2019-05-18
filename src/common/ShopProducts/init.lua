local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")

local Assets = require(common:WaitForChild("Assets"))

local by = require(common.util:WaitForChild("by"))
local products = require(common.util:WaitForChild("compileSubmodulesToArray"))(script, true)

-- Compile basic assets based on rarity
local basicAssets = Assets.basic

-- generic price table for basic assets
local priceTable = {
    [1] = 100,
    [2] = 300,
    [3] = 1000,
    [4] = 10000,
    [5] = 15000,
    [6] = 30000,
}

for id, asset in pairs(Assets.basic) do
    local newProduct = {
        id = id,
        price = priceTable[asset.rarity or 1],
        onSale = true,
    }
    table.insert(products,newProduct)
end

local function isLessExpensive(asset1,asset2)
    return asset1.price < asset2.price
end

table.sort(products,isLessExpensive)

return {
    all = products,
    byId = by("id", products),
}