local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local client = script.Parent.Parent
local assetModels = ReplicatedStorage:WaitForChild("assetmodels")
local gameStuff = assetModels:WaitForChild("gameStuff")
local coinbin = workspace:WaitForChild("coinbin")

local Components = require(client:WaitForChild("Components"))

local CoinSpawner = {}

local function getCoinModel(name)
    return gameStuff:FindFirstChild(name or "coin") or gameStuff:FindFirstChild("coin")
end

function CoinSpawner:spawnCoin(spawnPart)
    local spawnConfig = spawnPart:FindFirstChild("spawnConfig")
    if spawnConfig then
        spawnConfig = require(spawnConfig)
    else
        spawnConfig = {
            coinModel = "coin",
        }
    end

    local newCoinModel = getCoinModel(spawnConfig.coinModel):Clone()

    newCoinModel.CFrame = spawnPart.CFrame
    newCoinModel.Parent = coinbin
    spawnPart.Transparency = 1

    CollectionService:AddTag(newCoinModel,"Coin")
    local coinComponent = self.recsCore:getComponent(newCoinModel, Components.Coin)
    coinComponent.spawnPart = spawnPart
end

function CoinSpawner:spawnAllCoins()
    for _, instance in pairs(CollectionService:GetTagged("coin_spawn")) do
        self:spawnCoin(instance)
    end
end

function CoinSpawner:init()

end

function CoinSpawner:start(loader)
    self.recsCore = loader:getModule("RecsCoreContainer").recsCore
    self:spawnAllCoins()
end

return CoinSpawner