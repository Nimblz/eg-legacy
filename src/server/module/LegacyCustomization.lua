local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local util = common:WaitForChild("util")
local remote = ReplicatedStorage:WaitForChild("remote")

local requestHatEvent = remote:WaitForChild("RequestHat")
local requestColorEvent = remote:WaitForChild("RequestColor")

local HatUtil = require(util:WaitForChild("HatUtil"))

local LegacyCustomization = {}

function LegacyCustomization:init()
    requestHatEvent.OnServerEvent:Connect(function(player,hat)
        assert(hat and typeof(hat) == "Instance" and hat:FindFirstChild("HatAttachment"))
        local success, msg = pcall(HatUtil.equipHatToPlayer, player, hat)

        if not success then
            warn(msg)
        end
    end)

    requestColorEvent.OnServerEvent:Connect(function(player,color)
        assert(color and typeof(color) == "Color3")

        local Character = player.Character

        if Character then
            for _,v in pairs(Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.Color = color
                end
            end
        end
    end)
end

return LegacyCustomization