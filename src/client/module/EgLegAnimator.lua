-- Attaches animators to you and ur frens

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local common = ReplicatedStorage:WaitForChild("common")
local object = common:WaitForChild("object")

local LegAnimator = require(object:WaitForChild("LegAnimatorObject"))

local EgLegAnimator = {}

local animators = {}

local function attachNewAnimator(rig)
	print("Attached to:", rig)

	local humanoid = rig:WaitForChild("Humanoid")
	local animator = LegAnimator.new(rig)

	animators[rig] = animator

	humanoid.Died:Connect(function()
		animators[rig] = nil
	end)

	return animator
end

local function bindAttacher(player)
	player.CharacterAdded:Connect(function(char)
		attachNewAnimator(char)
	end)
end

local function attachAnimatorsToAllPlayers()
	for _,player in pairs(Players:GetPlayers()) do
		local rig = player.Character
		if rig then
			attachNewAnimator(rig)
		end
		bindAttacher(player)
	end
end

function EgLegAnimator:renderStep(elapsed,dt)

	for _,animator in pairs(animators) do
		animator:step(elapsed,dt)
	end

end

function EgLegAnimator:init()
	attachAnimatorsToAllPlayers()

	Players.PlayerAdded:Connect(function(player)
		bindAttacher(player)
	end)

	game:GetService("RunService").RenderStepped:Connect(function() self:renderStep() end)
end

return EgLegAnimator