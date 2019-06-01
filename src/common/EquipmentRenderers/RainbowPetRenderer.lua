-- object based pets renderer, default renderer for pets.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local Assets = require(common:WaitForChild("Assets"))
local PetRenderer = require(script.Parent.PetRenderer)

local getAssetModel = require(common.util:WaitForChild("getAssetModel"))

local RAINBOW_INTENSITY = 4

local RainbowPetRenderer = setmetatable({},{__index = PetRenderer})

local function createModel(assetId)
    local newModel = getAssetModel(assetId):Clone()

    newModel.CanCollide = false
    newModel.Anchored = true
    newModel.Locked = true

    return newModel
end

function RainbowPetRenderer.new(assetId,rig, client)
    -- create hat for this rig
    local self = setmetatable(PetRenderer.new(assetId,rig,client),{__index = RainbowPetRenderer})

    return self
end

function RainbowPetRenderer:update(client)
    PetRenderer.update(self,client)

    local viewModel = self.viewModel
    if not viewModel then return end
    local mesh = viewModel:FindFirstChild("Mesh")

    local now = (tick()/3)%1
    local newColor = Color3.fromHSV(now,0.7,1)

    viewModel.Color = newColor

    if mesh then
        mesh.VertexColor = Vector3.new(
            newColor.R*RAINBOW_INTENSITY,
            newColor.G*RAINBOW_INTENSITY,
            newColor.B*RAINBOW_INTENSITY
        )
    end
end

return RainbowPetRenderer