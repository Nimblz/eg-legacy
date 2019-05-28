-- server side coin tracking

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))
local Selectors = require(common:WaitForChild("Selectors"))
local Signal = require(lib:WaitForChild("Signal"))

local RESPAWN_TIME = 60*5 -- secs it takes for a coin to reappear
local COLLECTION_RANGE_PADDING = 3 -- padding for collection range

local store
local api

local Coins = {}

local coinCollections = {}
local coinSpawns = {}
local coinsInLast5Secs = {}

local function onPlayerJoin(player)
    coinCollections[player] = {}
end

local function onPlayerRemoving(player)
    coinCollections[player] = nil
end

local function bindCoinRespawn(player,coinPart)
    spawn(function()
        wait(RESPAWN_TIME)
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

        local spawnConfig = coinPart:FindFirstChild("spawnConfig")
        if spawnConfig then
            spawnConfig = require(spawnConfig)
        else
            spawnConfig = {
                value = 1;
            }
        end

        store:dispatch(Actions.COIN_ADD(player,spawnConfig.value or 1))
        local state = store:getState()
        Coins.coinCollected:fire(player,Selectors.getCoins(state,player))
        coinsInLast5Secs[player] = (coinsInLast5Secs[player] or 0) + 1
        if coinsInLast5Secs[player] > 50 then
            player:Kick("Collecting coins too fast :( The server might be lagging. Or are you cheating?")
        end
        bindCoinRespawn(player,coinPart)
    end
end

function Coins:init()
    Coins.coinCollected = Signal.new()

    for _,v in pairs(CollectionService:GetTagged("coin_spawn")) do
        coinSpawns[v] = v
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