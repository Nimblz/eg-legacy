local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remote = ReplicatedStorage:WaitForChild("remote")
local Common = ReplicatedStorage:WaitForChild("common")

local Common_Module = Common:WaitForChild("module")

local RequestReloadEvent = Remote:WaitForChild("RequestReloadCharacter")
local RequestHatEvent = Remote:WaitForChild("RequestHat")
local RequestColorEvent = Remote:WaitForChild("RequestColor")

local HatUtil = require(Common_Module:WaitForChild("HatUtil"))

RequestReloadEvent.OnServerEvent:Connect(function(player)
	local H = player.Character:FindFirstChild("Humanoid")

	if H then
		H.Health = 0
	end
end)

RequestHatEvent.OnServerEvent:Connect(function(player,hat)
	local success, msg = pcall(HatUtil.EquipHatToPlayer, player, hat)

	if not success then
		warn(msg)
	end
end)

RequestColorEvent.OnServerEvent:Connect(function(player,color)
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