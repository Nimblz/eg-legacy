-- server side coin tracking

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))
local Signal = require(lib:WaitForChild("Signal"))

local RESPAWN_TIME = 120 -- secs it takes for a coin to reappear
local COLLECTION_RANGE_PADDING = 3 -- padding for collection range

local store
local api

local Coins = {}

local coinCollections = {}
local coinSpawns = {}

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

        store:dispatch(Actions.COIN_ADD(player,1))
        local state = store:getState()
        local playerState = state.players[player]
        if playerState then
            local coinCount = (playerState.stats or {}).coins
            Coins.coinCollected:fire(player,coinCount)
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
end

function Coins:start(server)
    store = server.store
    api = server.api
end

return Coins