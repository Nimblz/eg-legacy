local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local object = common:WaitForChild("object")
local util = common:WaitForChild("util")
local remote = ReplicatedStorage:WaitForChild("remote")

local requestReloadEvent = remote:WaitForChild("RequestReloadCharacter")
local requestHatEvent = remote:WaitForChild("RequestHat")
local requestColorEvent = remote:WaitForChild("RequestColor")

local HatUtil = require(util:WaitForChild("HatUtil"))

requestReloadEvent.OnServerEvent:Connect(function(player)
	local H = player.Character:FindFirstChild("Humanoid")

	if H then
		H.Health = 0
	end
end)

requestHatEvent.OnServerEvent:Connect(function(player,hat)
	local success, msg = pcall(HatUtil.EquipHatToPlayer, player, hat)

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