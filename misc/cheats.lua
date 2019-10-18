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
    wait(4/30)
end
_G.coinGrabbing = false

-- You gotta have access to server console to use below --

-- give everyone in server coins

local Players = game:GetService("Players")
local amount = 1000
local server = _G.server

for _, player in pairs(Players:GetPlayers()) do
    server.store:dispatch({type = "COIN_ADD", coins = amount, player = player, replicateTo = player})
end

-- give everyone in server candy

local Players = game:GetService("Players")
local amount = 1000
local store = _G.store

for _, player in pairs(Players:GetPlayers()) do
    store:dispatch({type = "CANDY_ADD", candy = amount, player = player, replicateTo = player})
end

-- give everyone in server an asset

local Players = game:GetService("Players")
local assetId = "pet_babyscoobis"
local server = _G.server

for _, player in pairs(Players:GetPlayers()) do
    server.store:dispatch({type = "ASSET_GIVE", assetId="pet_babyscoobis", player = player, replicateTo = player})
end

-- make people not crowd me

local Players = game:GetService("Players")
local VIP = Players:FindFirstChild("Nimblz")
local BURNINATE_DIST = 12

local isBurninating = {}

local function burninate(player)
    if player == VIP then return end
    local character = player.Character
    local vipCharacter = VIP.Character
    if not character then return end
    if not vipCharacter then return end
    local charRoot = character:FindFirstChild("HumanoidRootPart")
    local vipRoot = vipCharacter:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not charRoot then return end
    if not vipRoot then return end
    if not humanoid then return end
    local charPos = charRoot.Position
    local vipPos = vipRoot.Position
    local dist = (charPos-vipPos).Magnitude
    if dist < BURNINATE_DIST and humanoid.Health > 0 and not isBurninating[character] then
        isBurninating[character] = true
        -- set fire then explode
        spawn(function() -- do on new thread, so we dont block setting fire to everyone else near VIP
            local newFire = Instance.new("Fire")
            newFire.Parent = charRoot
            newFire.Size = 10
            wait(0.3)
            local newExplosion = Instance.new("Explosion")
            newExplosion.BlastRadius = 0
            newExplosion.BlastPressure = 0
            newExplosion.Position = charPos
            newExplosion.Parent = workspace

            humanoid:TakeDamage(humanoid.MaxHealth)
            isBurninating[character] = false
        end)
    end
end

local sign = Instance.new("Part")
local surfGui = Instance.new("SurfaceGui",sign)
local textLabel = Instance.new("TextLabel",surfGui)

sign.Size = Vector3.new(5,5,0.5)
sign.Color = Color3.new(1,1,1)
sign.Anchored = true
sign.CanCollide = false

surfGui.CanvasSize = Vector2.new(400,400)

textLabel.Size = UDim2.new(1,0,1,0)
textLabel.Text = "STAY BACK. IM HIGHLY FLAMMABLE"
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.new(0,0,0)
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextScaled = true

sign.Parent = Workspace

_G.BURNINATE = true
while _G.BURNINATE do
    local vipCharacter = VIP.Character
    if not vipCharacter then return end
    local vipRoot = vipCharacter:FindFirstChild("HumanoidRootPart")
    if not vipRoot then return end
    for _,player in pairs(Players:GetPlayers()) do
        burninate(player)
    end
    sign.CFrame = vipRoot.CFrame * CFrame.new(0,5,0)
    wait(0.1)
end

sign:Destroy()

-- D A N G E R Z O N E --

-- wipe a save
local playerToWipe = game:GetService("Players"):FindFirstChild("Nimblz")
_G.server.store:dispatch({
    type = "PLAYER_ADD",
    player = playerToWipe,
    saveData = {},
    replicateBroadcast = true
})