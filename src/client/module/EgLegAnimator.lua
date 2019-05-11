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
		print("Removing animator for: ", rig)
		animators[rig] = nil
	end)

	rig.AncestryChanged:Connect(function(newChild,newParent)
		if newParent == nil then
			print("Removing animator for: ", rig)
			animators[rig] = nil
		end
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
			spawn(function()
				attachNewAnimator(rig)
			end)
		end
		bindAttacher(player)
	end
end

function EgLegAnimator:renderStep(elapsed,dt)

	for rig,animator in pairs(animators) do
		if rig and rig:FindFirstChild("Torso") then
			animator:step(elapsed,dt)
		end
	end

end

function EgLegAnimator:init()
	attachAnimatorsToAllPlayers()

	Players.PlayerAdded:Connect(function(player)
		bindAttacher(player)
	end)
	local start = tick()
	local elapsed = tick()-start
	local now = tick()
	local last = now
	game:GetService("RunService"):BindToRenderStep("egleg",Enum.RenderPriority.Last.Value,function()
		now = tick()
		local dt = now - last
		last = now
		self:renderStep(elapsed,dt)
	end)
end

return EgLegAnimator