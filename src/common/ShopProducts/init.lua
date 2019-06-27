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
    [1] = 75,
    [2] = 250,
    [3] = 750,
    [4] = 3000,
    [5] = 10000,
    [6] = 25000,
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

local function gnomeSort(a, comp)
    local i, j = 2, 3

    while i <= #a do
        if comp(a[i-1],a[i]) then
            i = j
            j = j + 1
        else
            a[i-1], a[i] = a[i], a[i-1] -- swap
            i = i - 1
            if i == 1 then -- 1 instead of 0
                i = j
                j = j + 1
            end
        end
    end
end

local function comparison(product1,product2)
    local asset1 = Assets.byId[product1.id]
    local asset2 = Assets.byId[product2.id]



    local isLessExpensive = (product1.price < product2.price)
    local isLessOrEqualRarity = (asset1.rarity <= asset2.rarity)
    return isLessExpensive and isLessOrEqualRarity
end

gnomeSort(products,comparison)

return {
    all = products,
    byId = by("id", products),
}