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

local RESPAWN_TIME = 30 -- secs it takes for a coin to reappear

local store

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
        CoinRespawnEvent:FireClient(player,coinPart)
    end)
end

local function requestCoinCollect(player,coinPart)
    print(typeof(coinPart))
    assert(typeof(coinPart) == "Instance", "arg 2 must be a part, got:"..tostring(coinPart))
    assert(coinPart:IsA("BasePart"), "arg 2 must be a part, got:"..tostring(coinPart))
    assert(coinSpawns[coinPart], "Invalid coin spawn")

    if not coinCollections[player][coinPart] then
        coinCollections[player][coinPart] = true

        store:dispatch(Actions.COIN_ADD(player,1))

        bindCoinRespawn(player,coinPart)
    end
end

function Coins:init()

    for _,v in pairs(CollectionService:GetTagged("coin_spawn")) do
        coinSpawns[v] = v
    end

    Players.PlayerAdded:Connect(onPlayerJoin)
    Players.PlayerAdded:Connect(onPlayerRemoving)
end

function Coins:start(server)

    store = server.store

    RequestCoinCollectEvent.OnServerEvent:connect(requestCoinCollect)
end

return Coins