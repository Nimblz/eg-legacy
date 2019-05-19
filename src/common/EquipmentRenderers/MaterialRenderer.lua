-- object based material renderer, default renderer for materials.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local Assets = require(common:WaitForChild("Assets"))

local MaterialRenderer = {}

local blacklist = {
    HumanoidRootPart = true,
    Head = true,
}

local function applyMaterialToRig(rig,color,material,reflectance,transparency)
    for _,instance in pairs(rig:GetChildren()) do
        if instance:IsA("BasePart") and not blacklist[instance.Name] then
            instance.Color = color or BrickColor.new("White").Color
            instance.Material = material or Enum.Material.Plastic
            instance.Reflectance = reflectance or 0
            instance.Transparency = transparency or 0
        end
    end
end

function MaterialRenderer.new(assetId,rig)
    local self = setmetatable({},{__index = MaterialRenderer})
    self.rig = rig
    self.assetId = assetId
    local materialAsset = Assets.byId[assetId]
    if materialAsset and materialAsset.metadata then
        applyMaterialToRig(
            rig,
            materialAsset.metadata.color,
            materialAsset.metadata.material,
            materialAsset.metadata.reflectance,
            materialAsset.metadata.transparency
        )
    end

    return self
end

function MaterialRenderer:update()
    -- nothing needed here
end

function MaterialRenderer:destroy()
    applyMaterialToRig(self.rig, nil, nil, nil, nil)
    self.rig = nil
end

return MaterialRenderer