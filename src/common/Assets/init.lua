local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")

local by = require(common:WaitForChild("by"))
local assets = require(common:WaitForChild("compileSubmodulesToArray"))(script, true)

local function isLessRare(asset1,asset2)
    return asset1.rarity < asset2.rarity
end

table.sort(assets,isLessRare)

return {
    all = assets,
    byId = by("id", assets),
}