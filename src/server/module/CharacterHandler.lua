local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local egRig = StarterPlayer:WaitForChild("StarterCharacter")

local ServerScriptService = game:GetService("ServerScriptService")
local util = ServerScriptService:WaitForChild("util")

local RigUtil = require(util:WaitForChild("RigUtil"))

local RESPAWN_TIME = 0.5

local CharacterHandler = {}

local function bindRespawn(player,rig)
    local humanoid = rig:FindFirstChild("Humanoid")

    if humanoid then
        humanoid.Died:Connect(function()
            wait(RESPAWN_TIME)
            loadCharacter(player)
        end)
    end
end

local function loadCharacter(player)
    local newRig = egRig:Clone()

    newRig.Name = player.Name

    RigUtil.configureRig(newRig)

    newRig.Parent = Workspace

    player.Character = newRig

    newRig:MoveTo(Vector3.new(0,100,30))

    bindRespawn(player,newRig)
end

function CharacterHandler:init()
    Players.PlayerAdded:Connect(function(player)
        loadCharacter(player)
    end)

    for _,player in pairs(Players:GetPlayers()) do
        loadCharacter(player)
    end
end

return CharacterHandler