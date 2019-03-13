-- client side coins
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local model = ReplicatedStorage:WaitForChild("model")

local localPlayer = Players.LocalPlayer

local ANIM_DIST = 256
local COIN_SOUND_ID = 1453122289

local Sound

local Coins = {}

local api

local coinEnts = {}
local coinSpawns = CollectionService:GetTagged("coin_spawn")

local coinBin = Workspace:WaitForChild("coinbin")

local function playerFromPart(part)
    local Char = part.Parent
    return Players:GetPlayerFromCharacter(Char)
end

local function collectCoin(coinSpawn, coinEnt)
    api:requestCoinCollect(coinSpawn)

    coinEnt.viewModel:Destroy()
    coinEnt.cFrame = nil
    coinEnt.spawnPart = nil
    coinEnts[coinSpawn] = nil

    if Sound then
        local RandomPitch = 1 + (math.random()*0.2 - 0.1)
        Sound:playSound(COIN_SOUND_ID,0.5,RandomPitch,coinSpawn)
    end

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

local function spawnCoin(spawnPart)
    local newCoin = {
        viewModel = model.Coin:Clone(),
        cFrame = spawnPart.CFrame,
        spawnPart = spawnPart,
        timeOffset = math.random() * 2
    }

    newCoin.viewModel.Parent = coinBin
    newCoin.viewModel.CFrame = newCoin.cFrame
    coinEnts[spawnPart] = newCoin

    local touchConnection
    touchConnection = spawnPart.Touched:Connect(function(hit)
        local touchedPlayer = playerFromPart(hit)

        if localPlayer == touchedPlayer then
            collectCoin(spawnPart, newCoin)

            touchConnection:Disconnect()
        end
    end)

    return newCoin
end

local function spawnAllCoins()
    for _,coinSpawn in pairs(coinSpawns) do
        coinSpawn.Transparency = 1
        spawnCoin(coinSpawn)
    end
    print("Total coin entities: "..#coinSpawns)
end

function Coins:spawnCoin(spawnPart)
    return spawnCoin(spawnPart)
end

function Coins:start(client)
    api = client.api
    spawnAllCoins()

    RunService:BindToRenderStep("coins",Enum.RenderPriority.Character.Value-1,update)
    Sound = client:getModule("Sound")
end

return Coins