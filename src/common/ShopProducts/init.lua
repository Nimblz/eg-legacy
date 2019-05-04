local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")

local by = require(common:WaitForChild("by"))
local products = require(common:WaitForChild("compileSubmodulesToArray"))(script, true)

local function isLessExpensive(asset1,asset2)
    return asset1.price < asset2.price
end

table.sort(products,isLessExpensive)

return {
    all = products,
    byId = by("id", products),
}