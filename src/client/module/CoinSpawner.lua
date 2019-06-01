local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local client = script.Parent.Parent
local assetModels = ReplicatedStorage:WaitForChild("assetmodels")
local gameStuff = assetModels:WaitForChild("gameStuff")
local coinbin = workspace:WaitForChild("coinbin")

local Components = require(client:WaitForChild("Components"))

local CoinSpawner = {}

local coinTypes = {
    default = {
        coinModel = "coin",
    },
    redcoin = {
        coinModel = "redcoin",
    },
    bluecoin = {
        coinModel = "bluecoin",
    },
    purplecoin = {
        coinModel = "purplecoin",
    },
    greencoin = {
        coinModel = "greencoin",
    },
    silvercoin = {
        coinModel = "silvercoin",
    },
    crystalcoin = {
        coinModel = "crystalcoin",
    },
    cosmiccoin = {
        coinModel = "cosmiccoin",
    },
}

local tagCoinTypes = {
    coin_spawn = "default",
    redcoin_spawn = "redcoin",
    bluecoin_spawn = "bluecoin",
    greencoin_spawn = "greencoin",
    purplecoin_spawn = "purplecoin",
}

local function getSpawnerType(instance)
    local tags = CollectionService:GetTags(instance)

    for _,tag in pairs(tags) do
        if tagCoinTypes[tag] then
            return tagCoinTypes[tag]
        end
    end
end

local function getCoinModel(name)
    return gameStuff:FindFirstChild(name or "coin") or gameStuff:FindFirstChild("coin")
end

function CoinSpawner:spawnCoin(spawnPart)
    local spawnConfig = spawnPart:FindFirstChild("spawnConfig")
    if spawnConfig then
        spawnConfig = require(spawnConfig)
    else
        local spawnTag = getSpawnerType(spawnPart)
        if not spawnTag then return end
        spawnConfig = coinTypes[spawnTag or "default"]
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
    for tagname,_ in pairs(tagCoinTypes) do
        for _, instance in pairs(CollectionService:GetTagged(tagname)) do
            self:spawnCoin(instance)
        end
    end

end

function CoinSpawner:init()

end

function CoinSpawner:start(loader)
    self.recsCore = loader:getModule("RecsCoreContainer").recsCore
    self:spawnAllCoins()
end

return CoinSpawner