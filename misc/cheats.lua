-- cheats that can be run in the command bar, why let the script kiddies
-- write the scripts when I can have all the fun myself :P

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

-- You gotta have access to server console to use below --

-- give everyone in server coins

local Players = game:GetService("Players")
local amount = 2500
local server = _G.server

for _, player in pairs(Players:GetPlayers()) do
    server.store:dispatch({type = "COIN_ADD", coins = amount, player = player, replicateTo = player})
end