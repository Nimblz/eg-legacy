-- object based hat renderer, default renderer for hats.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local Assets = require(common:WaitForChild("Assets"))

local MaterialRenderer = {}

local function applyMaterialToRig(rig,color,material)
    for _,instance in pairs(rig:GetChildren()) do
        if instance:IsA("BasePart") then
            instance.Color = color or BrickColor.new("White").Color
            instance.Material = material or Enum.Material.Plastic
        end
    end
end

function MaterialRenderer.new(assetId,rig)
    local self = setmetatable({},{__index = MaterialRenderer})
    self.rig = rig
    local materialAsset = Assets.byId[assetId]
    if materialAsset then
        applyMaterialToRig(rig,materialAsset.metadata.color,materialAsset.metadata.material)
    end

    return self
end

function MaterialRenderer:update()
    -- nothing needed here
end

function MaterialRenderer:destroy()
    applyMaterialToRig(self.rig, nil, nil)
end

return MaterialRenderer