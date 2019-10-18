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

local CandySystem = RECS.System:extend("CandySystem")

local COLLECT_SOUND_ID = 13075805

function CandySystem:touched(coin, instance, hit)
    if hitIsYou(hit) then
        self.api:requestCandyCollect(coin.spawnPart)
        instance:Destroy()

        local Sound = self:getClientModule("Sound")

        if Sound then
            local pitch = 1.1 + (math.random()*0.2)
            Sound:playSound(COLLECT_SOUND_ID,0.5,pitch,coin.spawnPart)
        end
    end
end

function CandySystem:addCoin(instance,coin)
    instance.Touched:Connect(function(hit)
        self:touched(coin, instance, hit)
    end)
end

function CandySystem:init()

    self.maid.componentAdded =
        self.core:getComponentAddedSignal(Components.Candy):Connect(
            function(instance, coin)
                self:addCoin(instance,coin)
            end)

    for instance, coin in self.core:components(Components.Candy) do
        self:addCoin(instance, coin)
    end
end

return CandySystem