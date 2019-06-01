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
local TILE_SIZE = 128

local function pointsCloserThan(p1,p2,dist)
    local delta = p1-p2

    return ((delta.X*delta.X) + (delta.Y*delta.Y) + (delta.Z*delta.Z)) <= dist*dist
end

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

function CoinSystem:getCoinTile(x,y)
    if not self.coinTiles[x] then
        return
    end
    if not self.coinTiles[x][y] then
        return
    end

    return self.coinTiles[x][y]
end

function CoinSystem:addCoinToTile(x,y,instance,coin)
    if not self.coinTiles[x] then
        self.coinTiles[x] = {}
    end
    if not self.coinTiles[x][y] then
        self.coinTiles[x][y] = {}
    end

    self.coinTiles[x][y][instance] = coin
end

function CoinSystem:removeCoinFromTile(x,y,instance)
    if not self.coinTiles[x] then
        return
    end
    if not self.coinTiles[x][y] then
        return
    end

    self.coinTiles[x][y][instance] = nil
end

function CoinSystem:addCoin(instance,coin)
    coin.originalCFrame = instance.CFrame
    coin.timeOffset = math.random() * 2 * math.pi
    local coinPos = instance.CFrame.p
    local tileX = math.floor(coinPos.X/TILE_SIZE)
    local tileY = math.floor(coinPos.Z/TILE_SIZE)

    instance.Touched:Connect(function(hit)
        self:coinTouched(coin, instance, hit)
        self:removeCoinFromTile(tileX,tileY,instance)
    end)
    self:addCoinToTile(tileX,tileY,instance,coin)
end

function CoinSystem:init()
    self.coinTiles = {}

    self.maid.componentAdded =
        self.core:getComponentAddedSignal(Components.Coin):Connect(
            function(instance, coin)
                self:addCoin(instance,coin)
            end)

    for instance, coin in self.core:components(Components.Coin) do
        self:addCoin(instance,coin)
    end
end

function CoinSystem:doCoinAnimationStep(instance,coin)
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

function CoinSystem:step()
    local coinsAnimated = 0
    local camera = Workspace.CurrentCamera
    local camPos = camera.CFrame.p

    local camTileX = math.floor(camPos.X/TILE_SIZE)
    local camTileY = math.floor(camPos.Z/TILE_SIZE)

    for x = -1,1 do
        for y = -1,1 do
            local coinTileX = camTileX+x
            local coinTileY = camTileY+y

            local coinTile = self:getCoinTile(coinTileX,coinTileY)
            if coinTile then
                for instance, coin in pairs(coinTile) do
                    local coinPos = coin.originalCFrame.p
                    local shouldSpin = pointsCloserThan(camPos,coinPos, ANIM_THRESHOLD)
                    if shouldSpin and coinsAnimated < MAX_COINS_PER_FRAME then
                        coinsAnimated = coinsAnimated + 1
                        self:doCoinAnimationStep(instance,coin)
                    end
                    if coinsAnimated >= MAX_COINS_PER_FRAME then
                        return
                    end
                end
            end
        end
    end
end

return CoinSystem