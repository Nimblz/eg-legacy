-- object based rainbow renderer, default renderer for rainbow.
local RainbowMaterialRenderer = {}

local function applyMaterialToRig(rig,color,material)
    for _,instance in pairs(rig:GetChildren()) do
        if instance:IsA("BasePart") then
            instance.Color = color or BrickColor.new("White").Color
            instance.Material = material or Enum.Material.Plastic
        end
    end
end

function RainbowMaterialRenderer.new(assetId,rig)
    local self = setmetatable({},{__index = RainbowMaterialRenderer})
    self.rig = rig

    return self
end

function RainbowMaterialRenderer:update()
    local t = (tick()/3)%(1)
    local tickColor = Color3.fromHSV(t,0.7,1)
    applyMaterialToRig(self.rig,tickColor, Enum.Material.Neon)
end

function RainbowMaterialRenderer:destroy()
    applyMaterialToRig(self.rig, nil, nil)
    self.rig = nil
end

return RainbowMaterialRenderer