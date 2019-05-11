local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Assets = require(common:WaitForChild("Assets"))

local getPlayerState = require(script.Parent.getPlayerState)

return function(state, player, assetId)

    local asset = Assets.byId[assetId]
    if not asset then return false end
    local catagory = AssetCatagories.byId[asset.type]
    if not catagory then return false end

    local equipment = getPlayerState(state,player).equipped

    local equipmentCatagory = equipment[asset.type]

    for _,equippedAssetId in pairs(equipmentCatagory) do
        if equippedAssetId == assetId then
            return true
        end
    end
    return false
end