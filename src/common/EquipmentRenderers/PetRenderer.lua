-- object based pets renderer, default renderer for pets.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local getAssetModel = require(common.util:WaitForChild("getAssetModel"))

local PetRenderer = {}

local function createModel(assetId)
    local newModel = getAssetModel(assetId):Clone()

    newModel.CanCollide = false
    newModel.Anchored = true
    newModel.Locked = true

    return newModel
end

function PetRenderer.new(assetId,rig)
    -- create hat for this rig
    local self = setmetatable({},{__index = PetRenderer})

    self.assetId = assetId
    self.rig = rig

    self.viewModel = createModel(assetId)

    local torso = rig:WaitForChild("Torso")

    self.viewModel.CFrame = torso.CFrame * CFrame.new(0,0,-5)

    self.viewModel.Parent = rig


    return self
end

function PetRenderer:update()
    local torso = self.rig:FindFirstChild("Torso")
    if not torso then return end
    self.viewModel.CFrame = CFrame.new(torso.CFrame.p) * CFrame.Angles(0,tick()%(math.pi*2),0) * CFrame.new(0,0,-5)
end

function PetRenderer:destroy()
    self.viewModel:Destroy()
    self.rig = nil
end

return PetRenderer