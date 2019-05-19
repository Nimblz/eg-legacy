local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local object = common:WaitForChild("object")

local Assets = require(common:WaitForChild("Assets"))
local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local EquipmentRenderers = require(common:WaitForChild("EquipmentRenderers"))

local EquipmentReconciler = require(object:WaitForChild("EquipmentReconciler"))

local EquipmentRenderer = {}
local equipmentReconciler
local renderers = {}

function EquipmentRenderer:start(loader)
    equipmentReconciler = EquipmentReconciler.new(loader)

    equipmentReconciler.equippedAsset:connect(function(player, assetId, equipmentBehavior)
        -- create renderer for asset
        local asset = Assets.byId[assetId]
        local rig = player.Character
        if asset then
            if asset.overrideRenderer then
                local newRenderer = EquipmentRenderers[asset.overrideRenderer].new(assetId,rig)
                renderers[equipmentBehavior] = newRenderer
            else
                local catagory = AssetCatagories.byId[asset.type]
                if catagory then
                    if rig then
                        local newRenderer = catagory.defaultRenderer.new(assetId,rig)
                        renderers[equipmentBehavior] = newRenderer
                    end
                end
            end
            print("Rendering "..assetId)
        end
    end)

    equipmentReconciler.unequippingAsset:connect(function(player, assetId, equipmentBehavior)
        -- destroy renderer for asset
        if renderers[equipmentBehavior] then
            renderers[equipmentBehavior]:destroy()
        end
        renderers[equipmentBehavior] = nil
    end)

    RunService.RenderStepped:connect(function()
        for _,renderer in pairs(renderers) do
            renderer:update()
        end
    end)
end

return EquipmentRenderer