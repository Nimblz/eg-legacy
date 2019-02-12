local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:WaitForChild("remote")
local coin = remote:WaitForChild("remote")

local RequestCoinCollectEvent = coin:WaitForChild("RequestCoinCollect")
local CoinRespawnEvent = coin:WaitForChild("RequestCoinCollect")

local RESPAWN_TIME = 10

local PlayerData

local Coins = {}

local coinCollections = {}
local coinSpawns = {}

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

    RequestCoinCollectEvent.OnServerEvent:connect(requestCoinCollect)
end

function Coins:start()

end

return Coins