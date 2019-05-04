local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Assets = require(common:WaitForChild("Assets"))

local equippedMax = require(script:WaitForChild("equippedMax"))

local function equip(equipped, max, action)
    equipped = equipped or {}

    if action.type == "ASSET_EQUIP" then
        local newEquipped = {}

        newEquipped[1] = action.assetId
        for i = 1, math.min(#equipped, max - 1) do
            newEquipped[i + 1] = equipped[i]
        end

        return newEquipped
    end

    return equipped
end

local function unequip(equipped,action)
    equipped = equipped or {}

    if action.type == "ASSET_UNEQUIP" then
        local newEquipped = {}
        for idx, value in ipairs(equipped) do
            if value == action.assetId then
                target = idx
            end
        end
    end
    return equipped
end

local function equip_unequip(equipped, max, action)
    equipped = equip(equipped,max,action)
    equipped = unequip(equipped, action)

    return equipped
end

local function equipmentCatagory(equipment, action)
    equipment = equipment or {}
    local newEquipment = {}

    -- to allow increasing thru devproducts, so people can have lots of hats :P $$
    newEquipment.max = equippedMax(equipment.max, action)
    newEquipment.equipped = equip_unequip(equipment.equipped, newEquipment.max, action)

    return newEquipment
end

return function(oldEquipped, action)
    oldEquipped = oldEquipped or {}
    return {
        hat = equipmentCatagory(oldEquipped.hat, action)
    }
end