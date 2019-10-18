-- server side coin tracking

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Promise = require(lib:WaitForChild("Promise"))
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Actions = require(common:WaitForChild("Actions"))
local Selectors = require(common:WaitForChild("Selectors"))
local Signal = require(lib:WaitForChild("Signal"))

local Coins = PizzaAlpaca.GameModule:extend("Coins")

local coinTypes = {
    default = {
        value = 1,
        respawnTime = 60,
    },
    redcoin = {
        value = 5,
        respawnTime = 120,
    },
    bluecoin = {
        value = 10,
        respawnTime = 180,
    },
    purplecoin = {
        value = 25,
        respawnTime = 240,
    },
    greencoin = {
        value = 50,
        respawnTime = 300,
    },
    silvercoin = {
        value = 100,
        respawnTime = 400,
    },
    crystalcoin = {
        value = 250,
        respawnTime = 600,
    },
    cosmiccoin = {
        value = 500,
        respawnTime = 1200,
    },
}

local tagCoinTypes = {
    coin_spawn = "default",
    redcoin_spawn = "redcoin",
    bluecoin_spawn = "bluecoin",
    greencoin_spawn = "greencoin",
    purplecoin_spawn = "purplecoin",
    silvercoin_spawn = "silvercoin",
    crystalcoin_spawn = "crystalcoin",
    cosmiccoin_spawn = "cosmiccoin",
}

local function getSpawnerType(instance)
    local tags = CollectionService:GetTags(instance)

    for _,tag in pairs(tags) do
        if tagCoinTypes[tag] then
            return tagCoinTypes[tag]
        end
    end
end

function Coins:create()
    self.coinCollections = {}
    self.coinSpawns = {}
    self.coinsInLast5Secs = {}
end

function Coins:onPlayerJoin(player)
    self.coinCollections[player] = {}
end

function Coins:onPlayerRemoving(player)
    self.coinCollections[player] = nil
end

function Coins:bindCoinRespawn(player,coinPart, coinType)
    spawn(function()
        wait(coinType.respawnTime or 0)
        if self.coinCollections[player] then
            self.coinCollections[player][coinPart] = false
            self.api:coinRespawn(player,coinPart)
        end
    end)
end

function Coins:requestCoinCollect(player,coinPart)
    assert(typeof(coinPart) == "Instance", "arg 2 must be a part, got:"..tostring(coinPart))
    assert(coinPart:IsA("BasePart"), "arg 2 must be a part, got:"..tostring(coinPart))
    assert(self.coinSpawns[coinPart], "Invalid coin spawn")

    if not self.coinCollections[player][coinPart] then
        self.coinCollections[player][coinPart] = true

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

        self.store:dispatch(Actions.COIN_ADD(player,spawnConfig.value or 1))
        local state = self.store:getState()
        Coins.coinCollected:fire(player,Selectors.getCoins(state,player))

        self.coinsInLast5Secs[player] = (self.coinsInLast5Secs[player] or 0) + 1
        if self.coinsInLast5Secs[player] > 30 then
            player:Kick("Collecting coins too fast :( The server might be lagging. Or are you cheating?")
        end

        self:bindCoinRespawn(player,coinPart,spawnConfig)
    end
end

function Coins:init()
    Coins.coinCollected = Signal.new()

    for tagname,_ in pairs(tagCoinTypes) do
        for _, instance in pairs(CollectionService:GetTagged(tagname)) do
            self.coinSpawns[instance] = instance
        end
    end

    for _,player in pairs(Players:GetPlayers()) do
		self:onPlayerJoin(player)
	end

    Players.PlayerAdded:Connect(function(player) self:onPlayerJoin(player) end)
    Players.PlayerRemoving:Connect(function(player) self:onPlayerRemoving(player) end)

    -- every 5 secs clear the coin collected table
    spawn(function()
        while true do
            self.coinsInLast5Secs = {}
            wait(5)
        end
    end)
end

function Coins:postInit()
    local apiWrapper = self.core:getModule("ServerApi")
    local storeContainer = self.core:getModule("StoreContainer")

    local function onAll(api, store)
        self.api = api
        self.store = store
    end

    Promise.all({
        apiWrapper:getApi(),
        storeContainer:getStore()
    }):andThen(function(resolved)
        return Promise.async(function(resolve,reject)
            onAll(unpack(resolved))
        end)
    end)
end

return Coins