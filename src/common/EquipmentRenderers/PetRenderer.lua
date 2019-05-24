-- object based pets renderer, default renderer for pets.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local Assets = require(common:WaitForChild("Assets"))

local getAssetModel = require(common.util:WaitForChild("getAssetModel"))

local PetRenderer = {}

local function createModel(assetId)
    local newModel = getAssetModel(assetId):Clone()

    newModel.CanCollide = false
    newModel.Anchored = true
    newModel.Locked = true

    return newModel
end

function PetRenderer.new(assetId,rig, client)
    -- create hat for this rig
    local self = setmetatable({},{__index = PetRenderer})

    self.assetId = assetId
    self.rig = rig

    self.viewModel = createModel(assetId)

    local torso = rig:WaitForChild("Torso")

    self.viewModel.CFrame = torso.CFrame * CFrame.new(0,0,-5)

    self.viewModel.Parent = workspace

    self.lastCF = CFrame.new(0,0,0)
    self.cframe = CFrame.new(0,0,0)
    self.offset = Vector3.new(0,0,0)

    local petAsset = Assets.byId[assetId]
    self.metadata = petAsset.metadata or {}
    self.nextSound = tick()+1

    return self
end

function PetRenderer:update(client)
    local root = self.rig:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if not self.viewModel then return end

    local diffVector = self.cframe.p-root.Position
    local separationVector = diffVector.Unit * 4
    local targetPos = root.Position + separationVector
    local targetCFrame = CFrame.new(targetPos) * (self.cframe - self.cframe.p)
    local heightOffset = math.sin((tick()*3)%(math.pi*2))*0.5

    if (targetPos-self.lastCF.p).Magnitude > 0.3 then -- moving, need to turn
        targetCFrame = CFrame.new(targetPos,targetPos + (targetPos-self.lastCF.p))
        local offsetAttachment = self.viewModel:FindFirstChild("offset")
        if offsetAttachment then
            targetCFrame = targetCFrame * offsetAttachment.CFrame:inverse()
        end
    end


    self.offset = Vector3.new(0,heightOffset,0)
    self.cframe = self.cframe:lerp(targetCFrame,0.1)
    self.lastCF = self.cframe

    self.viewModel.CFrame = self.cframe + self.offset

    if self.metadata.soundId then

        local pitch = self.metadata.basePitch or 1
        local deviation = self.metadata.pitchDevitation or 0.4
        local offset = self.metadata.pitchDevitationOffset or 0.2
        local minWait = self.metadata.minWait or 4
        local maxWait = self.metadata.maxWait or 10

        if tick() >= self.nextSound then
            self.nextSound = tick() + math.random(minWait,maxWait)

            client:getModule("Sound"):playSound(
                self.metadata.soundId,
                1,
                pitch - (math.random()*deviation - offset),
                self.viewModel,
                nil)
        end
    end
end

function PetRenderer:destroy()
    self.viewModel:Destroy()
    self.rig = nil
end

return PetRenderer