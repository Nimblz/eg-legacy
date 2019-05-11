local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Assets = require(common:WaitForChild("Assets"))

return function(equipped, action, cataId)
    equipped = equipped or {}

    local asset = Assets.byId[action.assetId]
    if asset then
        local catagory = AssetCatagories.byId[asset.type]
        if catagory and catagory.id == cataId then
            if action.type == "ASSET_UNEQUIP" then
                -- search for first occorance of assetid and remove it
                -- this is disgusting. but i cant think right now.
                local newEquipped = {}
                local removed = false -- removed the asset we wanted to
                for _, equippedAssetId in pairs(equipped) do
                    if equippedAssetId == action.assetId and not removed then
                        removed = true
                    else
                        table.insert(newEquipped,equippedAssetId)
                    end
                end
                return newEquipped
            end
        end
    end
    return equipped
end