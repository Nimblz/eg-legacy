-- increments the score of players that touch CoinTrigger instances, destroys those instances when touched.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local RECS = require(lib:WaitForChild("RECS"))
local Components = require(common:WaitForChild("RecsComponents"))

local SpinnySystem = RECS.System:extend("SpinnySystem")

local ANIM_THRESHOLD = 180
local MAX_SPINNY_PER_FRAME = 128
local TILE_SIZE = 128

local function pointsCloserThan(p1,p2,dist)
    local delta = p1-p2

    return ((delta.X*delta.X) + (delta.Y*delta.Y) + (delta.Z*delta.Z)) <= dist*dist
end

function SpinnySystem:getTile(x,y)
    if not self.tiles[x] then
        return
    end
    if not self.tiles[x][y] then
        return
    end

    return self.tiles[x][y]
end

function SpinnySystem:addToTile(x,y,instance,coin)
    if not self.tiles[x] then
        self.tiles[x] = {}
    end
    if not self.tiles[x][y] then
        self.tiles[x][y] = {}
    end
    self.spinnyIndex[instance] = Vector2.new(x,y)
    self.tiles[x][y][instance] = coin
end

function SpinnySystem:removeFromTile(x,y,instance)
    if not self.tiles[x] then
        return
    end
    if not self.tiles[x][y] then
        return
    end

    self.tiles[x][y][instance] = nil
end

function SpinnySystem:addSpinny(instance,coin)
    coin.originalCFrame = instance.CFrame
    coin.timeOffset = math.random() * 2 * math.pi
    local coinPos = instance.CFrame.p
    local tileX = math.floor(coinPos.X/TILE_SIZE)
    local tileY = math.floor(coinPos.Z/TILE_SIZE)

    self:addToTile(tileX,tileY,instance,coin)
end

function SpinnySystem:init()
    self.tiles = {}
    self.spinnyIndex = {}

    self.maid.componentAdded =
        self.core:getComponentAddedSignal(Components.Spinny):Connect(
            function(instance, spinny)
                self:addSpinny(instance,spinny)
            end)

    self.maid.componentRemoving =
    self.core:getComponentRemovingSignal(Components.Spinny):Connect(
        function(instance, spinny)
            local tileCoords = self.spinnyIndex[instance]
            self:removeFromTile(tileCoords.X,tileCoords.Y, instance)
        end)

    for instance, spinny in self.core:components(Components.Spinny) do
        self:addSpinny(instance,spinny)
    end
end

function SpinnySystem:doAnimationStep(instance,spinny)
    local time = tick() + spinny.timeOffset
    local sinVal = math.sin(time % (math.pi*2))
    local rotation = (time/2) % (math.pi*2)

    sinVal = sinVal * sinVal

    instance.CFrame = instance.CFrame:lerp(
        spinny.originalCFrame *
        CFrame.new(0,sinVal*1,0) *
        CFrame.Angles(0,rotation,0),
        0.1
    )
end

function SpinnySystem:step()
    local coinsAnimated = 0
    local camera = Workspace.CurrentCamera
    local camPos = camera.CFrame.p

    local camTileX = math.floor(camPos.X/TILE_SIZE)
    local camTileY = math.floor(camPos.Z/TILE_SIZE)

    for x = -1,1 do
        for y = -1,1 do
            local tileX = camTileX+x
            local tileY = camTileY+y

            local tile = self:getTile(tileX,tileY)
            if tile then
                for instance, spinny in pairs(tile) do
                    local pos = spinny.originalCFrame.p
                    local shouldSpin = pointsCloserThan(camPos, pos, ANIM_THRESHOLD)
                    if shouldSpin and coinsAnimated < MAX_SPINNY_PER_FRAME then
                        coinsAnimated = coinsAnimated + 1
                        self:doAnimationStep(instance, spinny)
                    elseif coinsAnimated >= MAX_SPINNY_PER_FRAME then
                        return
                    end
                end
            end
        end
    end
end

return SpinnySystem