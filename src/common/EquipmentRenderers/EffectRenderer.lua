-- object based hat renderer, default renderer for hats.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Assets = require(common:WaitForChild("Assets"))

local assetmodels = ReplicatedStorage:WaitForChild("assetmodels")
local effects = assetmodels:WaitForChild("effect")

local EffectRenderer = {}

local function cloneEffectsForAsset(id)
    local asset = Assets.byId[id]
    assert(asset, "Invalid asset id: "..id)
    assert(asset.metadata, ("Asset %s has invalid metadata for effect type"):format(id))
    local newEffects = {}

    for _,name in pairs(asset.metadata.effectInstances or {}) do
        local origEffect = effects:FindFirstChild(name)
        if origEffect then
            table.insert(newEffects,origEffect:Clone())
        else
            warn(("could not find effect %s for effect asset %s"):format(name,id))
        end
    end

    return newEffects
end

function EffectRenderer.new(assetId,rig)
    -- create hat for this rig
    local self = setmetatable({},{__index = EffectRenderer})

    self.assetId = assetId
    self.rig = rig
    local asset = Assets.byId[assetId]

    self.effectInstances = cloneEffectsForAsset(assetId)

    local torso = rig:WaitForChild("Torso")
    if not torso then return self end

    for _,effectInstance in pairs(self.effectInstances) do
        effectInstance.Parent = torso

        if effectInstance:IsA("Trail") then
            effectInstance.Attachment0 = torso:FindFirstChild("HatAttachment")
            effectInstance.Attachment1 = torso:FindFirstChild("TrailBottom")

            effectInstance.Color = ColorSequence.new(asset.metadata.effectColor3) or ColorSequence.new(Color3.new(1,1,1))
        end
    end

    return self
end

function EffectRenderer:update()
    -- nothing needed here
end

function EffectRenderer:destroy()
    for _,v in pairs(self.effectInstances or {}) do
        v:Destroy()
    end
    self.rig = nil
end

return EffectRenderer