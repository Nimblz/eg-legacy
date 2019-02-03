-- Attaches animators to you and ur frens

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Common = ReplicatedStorage:WaitForChild("common")
local Object = Common:WaitForChild("object")

local LegAnimator = require(Object:WaitForChild("LegAnimator"))

local EgLegAnimator = {}

local Animators = {}

local function AttachNewAnimator(rig)
	print("Attached to:", rig)

	local Humanoid = rig:WaitForChild("Humanoid")

	local Animator = LegAnimator.new(rig)

	Animators[rig] = Animator

	Humanoid.Died:Connect(function()
		Animators[rig] = nil
		Animator:Destroy()
	end)

	return Animator
end

local function BindAttacher(player)
	player.CharacterAdded:Connect(function(char)
		AttachNewAnimator(char)
	end)
end

local function AttachAnimatorsToAllPlayers()
	for _,player in pairs(Players:GetPlayers()) do
		local Rig = player.Character
		if Rig then
			AttachNewAnimator(Rig)
		end
		BindAttacher(player)
	end
end

function EgLegAnimator:RenderStep(elapsed,dt)

	for _,Animator in pairs(Animators) do
		Animator:Step(elapsed,dt)
	end

end

function EgLegAnimator:Init()
	AttachAnimatorsToAllPlayers()

	Players.PlayerAdded:Connect(function(player)
		BindAttacher(player)
	end)
end

return EgLegAnimator