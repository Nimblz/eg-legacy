-- increments the score of players that touch CoinTrigger instances, destroys those instances when touched.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local client = script.Parent.Parent
local util = common:WaitForChild("util")

local RECS = require(lib:WaitForChild("RECS"))
local Components = require(common:WaitForChild("RecsComponents"))

local hitIsYou = require(util:WaitForChild("hitIsYou"))

local CoinSystem = RECS.System:extend("CoinSystem")

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

function CoinSystem:addCoin(instance,coin)
    instance.Touched:Connect(function(hit)
        self:coinTouched(coin, instance, hit)
    end)
end

function CoinSystem:init()

    self.maid.componentAdded =
        self.core:getComponentAddedSignal(Components.Coin):Connect(
            function(instance, coin)
                self:addCoin(instance,coin)
            end)

    for instance, coin in self.core:components(Components.Coin) do
        self:addCoin(instance,coin)
    end
end

return CoinSystem