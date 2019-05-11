local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Assets = require(common:WaitForChild("Assets"))

return function(equipped, action, cataId)
    equipped = equipped or {}
    if action.type == "ASSET_EQUIP" then

        local asset = Assets.byId[action.assetId]
        if asset then
            local catagory = AssetCatagories.byId[asset.type]
            if catagory and catagory.id == cataId then
                local max = catagory.maxEquipped or 1
                local newEquipped = {}

                newEquipped[1] = action.assetId
                for i = 1, math.min(#equipped, max - 1) do
                    newEquipped[i + 1] = equipped[i]
                end

                return newEquipped
            end
        end
    end

    return equipped
end