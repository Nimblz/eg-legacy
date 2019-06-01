-- server side coin tracking

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))
local Selectors = require(common:WaitForChild("Selectors"))
local Signal = require(lib:WaitForChild("Signal"))

local COLLECTION_RANGE_PADDING = 3 -- padding for collection range

local store
local api

local Coins = {}

local coinCollections = {}
local coinSpawns = {}
local coinsInLast5Secs = {}

local coinTypes = {
    default = {
        value = 1,
        respawnTime = 60,
    },
    redcoin = {
        value = 10,
        respawnTime = 120,
    },
    bluecoin = {
        value = 50,
        respawnTime = 180,
    },
    purplecoin = {
        value = 100,
        respawnTime = 240,
    },
    greencoin = {
        value = 250,
        respawnTime = 300,
    },
    silvercoin = {
        value = 500,
        respawnTime = 400,
    },
    crystalcoin = {
        value = 1000,
        respawnTime = 600,
    },
    cosmiccoin = {
        value = 10000,
        respawnTime = 1200,
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

local function onPlayerJoin(player)
    coinCollections[player] = {}
end

local function onPlayerRemoving(player)
    coinCollections[player] = nil
end

local function bindCoinRespawn(player,coinPart, coinType)
    spawn(function()
        wait(coinType.respawnTime or 0)
        coinCollections[player][coinPart] = false
        api:coinRespawn(player,coinPart)
    end)
end

function Coins:requestCoinCollect(player,coinPart)
    assert(typeof(coinPart) == "Instance", "arg 2 must be a part, got:"..tostring(coinPart))
    assert(coinPart:IsA("BasePart"), "arg 2 must be a part, got:"..tostring(coinPart))
    assert(coinSpawns[coinPart], "Invalid coin spawn")

    if not coinCollections[player][coinPart] then
        coinCollections[player][coinPart] = true

        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local dist = (root.Position-coinPart.Position).Magnitude

        if dist > 40 then
            return -- too far away :O
        end

        local spawnConfig = coinPart:FindFirstChild("spawnConfig")
        if spawnConfig then
            spawnConfig = require(spawnConfig)
        else
            local spawnTag = getSpawnerType(coinPart)
            if not spawnTag then return end
            spawnConfig = coinTypes[spawnTag or "default"]
        end

        store:dispatch(Actions.COIN_ADD(player,spawnConfig.value or 1))
        local state = store:getState()
        Coins.coinCollected:fire(player,Selectors.getCoins(state,player))

        coinsInLast5Secs[player] = (coinsInLast5Secs[player] or 0) + 1
        if coinsInLast5Secs[player] > 30 then
            player:Kick("Collecting coins too fast :( The server might be lagging. Or are you cheating?")
        end

        bindCoinRespawn(player,coinPart,spawnConfig)
    end
end

function Coins:init()
    Coins.coinCollected = Signal.new()

    for tagname,_ in pairs(tagCoinTypes) do
        for _, instance in pairs(CollectionService:GetTagged(tagname)) do
            coinSpawns[instance] = instance
        end
    end

    for _,player in pairs(Players:GetPlayers()) do
		onPlayerJoin(player)
	end

    Players.PlayerAdded:Connect(onPlayerJoin)
    Players.PlayerAdded:Connect(onPlayerRemoving)

    -- every 5 secs clear the coin collected table
    spawn(function()
        while true do
            coinsInLast5Secs = {}
            wait(5)
        end
    end)
end

function Coins:start(server)
    store = server.store
    api = server.api
end

return Coins