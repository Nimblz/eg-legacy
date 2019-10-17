local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local assetModels = ReplicatedStorage:WaitForChild("assetmodels")
local gameStuff = assetModels:WaitForChild("gameStuff")
local candy = gameStuff:WaitForChild("candy")
local coinbin = workspace:WaitForChild("coinbin")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))

local CandySpawner = PizzaAlpaca.GameModule:extend("CandySpawner")


local function getModel()
    local candyModels = candy:GetChildren()

    return candyModels[math.random(#candyModels)]:Clone()
end

function CandySpawner:spawn(spawnPart)
    local newCoinModel = getModel()

    newCoinModel.CFrame = spawnPart.CFrame
    newCoinModel.Parent = coinbin
    spawnPart.Transparency = 1

    CollectionService:AddTag(newCoinModel,"Candy")
    CollectionService:AddTag(newCoinModel,"Spinny")
    local component = self.recsCore:getComponent(newCoinModel, "Candy")
    component.spawnPart = spawnPart
end

function CandySpawner:spawnAll()
    for _, instance in pairs(CollectionService:GetTagged("candy_spawn")) do
        self:spawn(instance)
    end
end


function CandySpawner:postInit()
    self.core:getModule("ClientRECSContainer"):getCore():andThen(function(recsCore)
        self.recsCore = recsCore
        self:spawnAll()
    end)
end

return CandySpawner