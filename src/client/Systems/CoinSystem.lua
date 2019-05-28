-- increments the score of players that touch CoinTrigger instances, destroys those instances when touched.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local client = script.Parent.Parent
local util = common:WaitForChild("util")

local RECS = require(lib:WaitForChild("RECS"))
local Components = require(client:WaitForChild("Components"))

local hitIsYou = require(util:WaitForChild("hitIsYou"))

local CoinSystem = RECS.System:extend("CoinSystem")

local ANIM_THRESHOLD = 180
local MAX_COINS_PER_FRAME = 128
local COIN_SOUND_ID = 1453122289

function CoinSystem:coinTouched(coin, instance, hit)
    if hitIsYou(hit) then
        self.api:requestCoinCollect(coin.spawnPart)
        instance:Destroy()

        local Sound = self:getClientModule("Sound")

        if Sound then
            local pitch = 1 + (math.random()*0.2 - 0.1)
            Sound:playSound(COIN_SOUND_ID,0.5,pitch,coin.spawnPart)
        end
    end
end

function CoinSystem:init()
    self.maid.componentAdded =
        self.core:getComponentAddedSignal(Components.Coin):Connect(
            function(instance, coin)
                coin.originalCFrame = instance.CFrame
                coin.timeOffset = math.random() * 2 * math.pi
                instance.Touched:Connect(function(hit)
                    self:coinTouched(coin, instance, hit)
                end)
            end)
    for instance, coin in self.core:components(Components.Coin) do
        coin.originalCFrame = instance.CFrame
        coin.timeOffset = math.random() * 2 * math.pi
        instance.Touched:Connect(function(hit)
            self:coinTouched(coin, instance, hit)
        end)
    end
end

function CoinSystem:step()
    local coinsAnimated = 0
    local camera = Workspace.CurrentCamera
    local camPos = camera.CFrame.p
    for instance, coin in self.core:components(Components.Coin) do
        local coinPos = coin.originalCFrame.p
        local shouldSpin = (camPos-coinPos).Magnitude < ANIM_THRESHOLD
        if shouldSpin and coinsAnimated < MAX_COINS_PER_FRAME then
            coinsAnimated = coinsAnimated + 1

            local time = tick() + coin.timeOffset
            local sinVal = math.sin(time % (math.pi*2))
            local rotation = (time/2) % (math.pi*2)

            sinVal = sinVal * sinVal

            instance.CFrame = instance.CFrame:lerp(
                coin.originalCFrame *
                CFrame.new(0,sinVal*1,0) *
                CFrame.Angles(0,rotation,0),
                0.1
            )
        end
    end
end

return CoinSystem