-- client side coins
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local remote = ReplicatedStorage:WaitForChild("remote")
local model = ReplicatedStorage:WaitForChild("model")
local remote_coin = remote:WaitForChild("coin")

local localPlayer = Players.LocalPlayer

local requestCoinCollectEvent = remote_coin:WaitForChild("RequestCoinCollect")
local coinRespawnEvent = remote_coin:WaitForChild("CoinRespawn")

local ANIM_DIST = 256

local Coins = {}

local coinEnts = {}
local coinSpawns = CollectionService:GetTagged("coin_spawn")

local coinBin = Workspace:WaitForChild("coinbin")

local function playerFromPart(part)
    local Char = part.Parent
    return Players:GetPlayerFromCharacter(Char)
end

local function collectCoin(coinSpawn)
    requestCoinCollectEvent:FireServer(coinSpawn)
end

local function spawnCoin(spawnPart)
    local newCoin = {
        viewModel = model.Coin:Clone(),
        cFrame = spawnPart.CFrame,
        spawnPart = spawnPart,
        timeOffset = math.random() * 2
    }

    newCoin.viewModel.Parent = coinBin
    coinEnts[spawnPart] = newCoin

    local touchConnection
    touchConnection = spawnPart.Touched:Connect(function(hit)
        local touchedPlayer = playerFromPart(hit)

        if localPlayer == touchedPlayer then
            collectCoin(spawnPart)
            newCoin.viewModel:Destroy()
            newCoin.cFrame = nil
            newCoin.spawnPart = nil

            coinEnts[spawnPart] = nil

            touchConnection:Disconnect()
        end
    end)

    return newCoin
end

local function update()
    for _,coin in pairs(coinEnts) do
        local camPos = Workspace.CurrentCamera.CFrame.p
        local coinPos = coin.cFrame.p

        if (camPos - coinPos).Magnitude < ANIM_DIST then
            local time = tick() + coin.timeOffset
            local sinVal = math.sin(time % (math.pi*2))
            local rotation = (time/2) % (math.pi*2)

            sinVal = sinVal * sinVal

            coin.viewModel.CFrame = coin.cFrame * CFrame.new(0,sinVal*1,0) * CFrame.Angles(0,rotation,0)
        end
    end
end

local function spawnAllCoins()
    for _,coinSpawn in pairs(coinSpawns) do
        coinSpawn.Transparency = 1
        spawnCoin(coinSpawn)
    end
end

function Coins:init()
    spawnAllCoins()

    coinRespawnEvent.OnClientEvent:Connect(spawnCoin)

    RunService:BindToRenderStep("coins",Enum.RenderPriority.Character.Value-1,update)
end

function Coins:start(client)
end

return Coins