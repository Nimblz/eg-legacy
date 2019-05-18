-- object based hat renderer, default renderer for hats.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local getAssetModel = require(common.util:WaitForChild("getAssetModel"))

local HatRenderer = {}

local function createAccessoryForHat(assetId)
    local model = getAssetModel(assetId):Clone()
    assert(model, "No model for hat: "..assetId)
    local newAccessory = Instance.new("Accessory")
    model.Name = "Handle"
    model.Anchored = false
    model.CanCollide = false
    model.Massless = true
    model.Parent = newAccessory

    return newAccessory
end

function HatRenderer.new(assetId,rig)
    -- create hat for this rig
    local self = setmetatable({},{__index = HatRenderer})

    self.assetId = assetId
    self.rig = rig

    self.viewModel = createAccessoryForHat(assetId)

    local torso = rig:WaitForChild("Torso")
    local torsoHatAttachment = torso:WaitForChild("HatAttachment")
    local hatAttachment = self.viewModel.Handle.HatAttachment
    local weld = Instance.new("Weld")

    weld.Part0 = torso
    weld.Part1 = self.viewModel.Handle

    weld.C0 = torsoHatAttachment.CFrame
    weld.C1 = hatAttachment.CFrame

    weld.Parent = self.viewModel.Handle

    self.viewModel.Parent = rig


    return self
end

function HatRenderer:update()
    -- nothing needed here
end

function HatRenderer:destroy()
    self.viewModel:Destroy()
    self.rig = nil
end

return HatRenderer