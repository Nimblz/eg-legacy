local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local object = common:WaitForChild("object")

local Assets = require(common:WaitForChild("Assets"))
local AssetCatagories = require(common:WaitForChild("AssetCatagories"))

local EquipmentReconciler = require(object:WaitForChild("EquipmentReconciler"))

local EquipmentRenderer = {}
local equipmentReconciler
local renderers = {}

function EquipmentRenderer:start(loader)
    equipmentReconciler = EquipmentReconciler.new(loader)

    equipmentReconciler.equippedAsset:connect(function(player, assetId, equipmentBehavior)
        -- create renderer for asset
        local asset = Assets.byId[assetId]
        if asset then
            local catagory = AssetCatagories.byId[asset.type]
            if catagory then
                local rig = player.Character
                if rig then
                    local newRenderer = catagory.defaultRenderer.new(assetId,rig)
                    renderers[equipmentBehavior] = newRenderer
                    print("Rendering "..assetId)
                end
            end
        end
    end)

    equipmentReconciler.unequippingAsset:connect(function(player, assetId, equipmentBehavior)
        -- destroy renderer for asset
        print(equipmentBehavior)
        if renderers[equipmentBehavior] then
            renderers[equipmentBehavior]:destroy()
        end
        renderers[equipmentBehavior] = nil
    end)
end

return EquipmentRenderer