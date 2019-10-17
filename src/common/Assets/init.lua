local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")

local by = require(common.util:WaitForChild("by"))
local compileSubmodulesToArray = require(common.util:WaitForChild("compileSubmodulesToArray"))
local assets = compileSubmodulesToArray(script, true)

for _, asset in pairs(assets) do
    asset.shopCatagory = asset.shopCatagory or asset.type
end

local function isLessRare(asset1,asset2)
    return asset1.rarity < asset2.rarity
end

table.sort(assets,isLessRare)

return {
    all = assets,
    byId = by("id", assets),
    basic = by("id", compileSubmodulesToArray(script.basic,true)) -- basic hats by id
}