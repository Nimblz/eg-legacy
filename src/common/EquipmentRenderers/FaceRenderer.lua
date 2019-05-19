-- object based faces renderer, default renderer for faces.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local Assets = require(common:WaitForChild("Assets"))

local FaceRenderer = {}

local function applyFaceToRig(rig,image)
    local torso = rig:FindFirstChild("Torso")
    if torso then
        local face = torso:FindFirstChild("Decal")
        if face then
            face.Texture = image or "rbxassetid://102312301"
        end
    end
end

function FaceRenderer.new(assetId,rig)
    local self = setmetatable({},{__index = FaceRenderer})
    self.rig = rig
    self.assetId = assetId
    local faceAsset = Assets.byId[assetId]
    if faceAsset then
        applyFaceToRig(rig,faceAsset.metadata.image)
    end

    return self
end

function FaceRenderer:update()
    -- nothing needed here
end

function FaceRenderer:destroy()
    applyFaceToRig(self.rig, nil)
    self.rig = nil
end

return FaceRenderer