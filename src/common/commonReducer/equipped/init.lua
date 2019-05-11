local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local AssetCatagories = require(common:WaitForChild("AssetCatagories"))

local equipmentCatagory = require(script:WaitForChild("equipmentCatagory"))

return function(state, action)
    state = state or {}

    local newState = {}
    for _,cata in pairs(AssetCatagories.all) do
        newState[cata.id] = equipmentCatagory(state[cata.id], action, cata.id)
    end

    return newState
end