-- consume coin --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local coinBin = Workspace:WaitForChild("coinbin")
local rig = Players.LocalPlayer.Character

local function getNearestCoin()
    local rigPos = rig.PrimaryPart.Position
    local coins = coinBin:GetChildren()
    local closestCoin = nil
    local closestDist = math.huge
    for _,coin in pairs(coins) do
        local coinPos = coin.Position
        local dist = (rigPos-coinPos).magnitude
        if dist < closestDist then
            closestCoin = coin
            closestDist = dist
        end
    end
    return closestCoin
end

-- in case you wanna stop it, set this to false
_G.coinGrabbing = true
while #coinBin:GetChildren() > 0 and _G.coinGrabbing do
    rig.PrimaryPart.CFrame = CFrame.new(getNearestCoin().Position)
    rig.PrimaryPart.Velocity = Vector3.new(0,0,0)
    RunService.RenderStepped:Wait() -- only wait 1 frame
end
_G.coinGrabbing = false

-- Rainbow --

local RunService = game:GetService("RunService")

-- in case you wanna stop it, set this to false
_G.rainbowing = true

local s = 0.8 -- saturation
local v = 1 -- value/brightness
local speed = 1/3 -- cycles per sec
while _G.rainbowing do
    local tickVal = (tick()*speed)%1 -- hue
    game.ReplicatedStorage.remote.RequestColor:FireServer(Color3.fromHSV(tickVal,s,v))
    RunService.RenderStepped:Wait()
end