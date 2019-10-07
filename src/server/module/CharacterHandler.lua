local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))

local RESPAWN_TIME = 0.5

local CharacterHandler = PizzaAlpaca.GameModule:extend("CharacterHandler")

local function bindRespawn(player)
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

function CharacterHandler:init()
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