-- server side coins

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local remote = ReplicatedStorage:WaitForChild("remote")
local remote_coin = remote:WaitForChild("coin")

local Actions = require(common:WaitForChild("Actions"))

local RequestCoinCollectEvent = remote_coin:WaitForChild("RequestCoinCollect")
local CoinRespawnEvent = remote_coin:WaitForChild("CoinRespawn")

local RESPAWN_TIME = 10 -- secs it takes for a coin to reappear

local store

local Coins = {}

local coinCollections = {}
local coinSpawns = CollectionService:GetTagged("coin_spawn")

local function onPlayerJoin(player)
    coinCollections[player] = {}
end

local function onPlayerRemoving(player)
    coinCollections[player] = nil
end

local function requestCoinCollect(player,coinPart)
    assert(typeof(coinPart) == "instance", "arg 2 must be a part, got:"..tostring(coinPart))
    assert(coinPart:IsA("BasePart"), "arg 2 must be a part, got:"..tostring(coinPart))
    assert(coinSpawns[coinPart], "Invalid coin spawn")

    if not coinCollections[player][coinPart] then
        coinCollections[player][coinPart] = true
    end
end

local function bindCoinRespawn(player,coinPart)
    spawn(function()
        wait(RESPAWN_TIME)
        coinCollections[player][coinPart] = false
        CoinRespawnEvent:FireClient(player,coinPart)
    end)
end

function Coins:init()

    Players.PlayerAdded:Connect(onPlayerJoin)
    Players.PlayerAdded:Connect(onPlayerRemoving)
end

function Coins:start(server)

    store = server.store

    RequestCoinCollectEvent.OnServerEvent:connect(requestCoinCollect)
end

return Coins