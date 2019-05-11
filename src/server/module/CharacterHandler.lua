local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local egRig = StarterPlayer:WaitForChild("StarterCharacter")

local ServerScriptService = game:GetService("ServerScriptService")
local util = ServerScriptService:WaitForChild("util")

local RigUtil = require(util:WaitForChild("RigUtil"))

local RESPAWN_TIME = 0.5

local CharacterHandler = {}

local bindRespawn

function bindRespawn(player)
    player.CharacterAdded:Connect(function(rig)
        local humanoid = rig:WaitForChild("Humanoid")
        if humanoid then
            humanoid.CameraOffset = Vector3.new(0,-1.6,0)
            humanoid:BuildRigFromAttachments()
            local connection
            connection = humanoid.Died:Connect(function()
                connection:Disconnect()
                wait(RESPAWN_TIME)
                player:LoadCharacter()
            end)
        end
    end)
end

function CharacterHandler:start()
    Players.PlayerAdded:Connect(function(player)
        bindRespawn(player)
        player:LoadCharacter()
    end)

    for _,player in pairs(Players:GetPlayers()) do
        bindRespawn(player)
        player:LoadCharacter()
    end
end

return CharacterHandler