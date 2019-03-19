-- Todo: Refactor E V E R Y T H A N G

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local common = ReplicatedStorage:WaitForChild("common")
local object = common:WaitForChild("object")
local util = common:WaitForChild("util")

local solveIK = require(util:WaitForChild("solveIK"))
local Leg = require(object:WaitForChild("Leg"))

local DOWN = Vector3.new(0,-1,0)

local WHITELIST = {
	Workspace:WaitForChild("staticworld")
}

local LegAnimator = {}

-- TODO: Move this somewhere else.
local function bezierSolve(V1,V2,V3,a)
	return V1:lerp(V2,a):lerp(V3,a)
end

function LegAnimator.new(rig)

	local UpperRightLeg = rig:WaitForChild("UpperRightLeg")
	local UpperLeftLeg = rig:WaitForChild("UpperLeftLeg")
	local LowerRightLeg = rig:WaitForChild("LowerRightLeg")
	local LowerLeftLeg = rig:WaitForChild("LowerLeftLeg")

	local RightHip = UpperRightLeg:WaitForChild("RightHip")
	local LeftHip = UpperLeftLeg:WaitForChild("LeftHip")

	local RightKnee = LowerRightLeg:WaitForChild("RightKnee")
	local LeftKnee = LowerLeftLeg:WaitForChild("LeftKnee")

	local self = setmetatable({

		Rig = rig,
		Root = rig:FindFirstChild("HumanoidRootPart"),
		Humanoid = rig:FindFirstChild("Humanoid"),

		LastStepped = nil,

		Legs = {
			Right = Leg.new(rig,RightHip,RightKnee),
			Left = Leg.new(rig,LeftHip,LeftKnee),
		},

	}, {__index = LegAnimator})

	self.Legs.Right:setOtherLeg(self.Legs.Left)
	self.Legs.Left:setOtherLeg(self.Legs.Right)

	return self
end

function LegAnimator:destroy()
end

local function setupFootTween(foot,target,stepTime)
	foot.StepStartTick = tick()
	foot.StepStart = foot.FootPos
	foot.FootTarget = target
	foot.StepTime = stepTime
	foot.Planted = false
end

function LegAnimator:walkStep(XZVel)

	local LeftLeg = self.Legs.Left
	local RightLeg = self.Legs.Right

	local Rig = self.Rig
	local Root = self.Root
	local Humanoid = self.Humanoid

	local StepVec = (((XZVel*2)/Humanoid.WalkSpeed) * Humanoid.HipHeight)
	local AvgFootPosition = LeftLeg.FootTarget:lerp(RightLeg.FootTarget,0.5)
	local LeftFootRayOrigin = (Root.CFrame * LeftLeg.Hip.C0).p + StepVec + Vector3.new(0,3,0)
	local RightFootRayOrigin = (Root.CFrame * RightLeg.Hip.C0).p + StepVec + Vector3.new(0,3,0)

	local LeftFootRay = Ray.new(LeftFootRayOrigin,DOWN*Humanoid.HipHeight*3)
	local RightFootRay = Ray.new(RightFootRayOrigin,DOWN*Humanoid.HipHeight*3)

	local _,LeftRayPos,_ = workspace:FindPartOnRayWithWhitelist(LeftFootRay,WHITELIST)
	local _,RightRayPos,_ = workspace:FindPartOnRayWithWhitelist(RightFootRay,WHITELIST)

	local TimeToReachLeftRayPos = (Rig.PrimaryPart.Position * Vector3.new(1,0,1) - LeftRayPos * Vector3.new(1,0,1)).Magnitude / XZVel.Magnitude
	local TimeToReachRightRayPos = (Rig.PrimaryPart.Position * Vector3.new(1,0,1) - RightRayPos * Vector3.new(1,0,1)).Magnitude / XZVel.Magnitude

	TimeToReachLeftRayPos = math.clamp(TimeToReachLeftRayPos,0,XZVel.Magnitude*Humanoid.HipHeight + 0.3)
	TimeToReachRightRayPos = math.clamp(TimeToReachRightRayPos,0,XZVel.Magnitude*Humanoid.HipHeight + 0.3)

	local Infront = Root.CFrame * CFrame.new(0,0,-1)
	local AvgAngle = XZVel.Unit:Dot((AvgFootPosition - (Infront.p)).Unit)

	if (XZVel.Magnitude < 1) then
		if (LeftLeg.FootTarget - LeftRayPos).Magnitude > 0.7 then
			setupFootTween(LeftLeg,LeftRayPos,0.2*(Humanoid.HipHeight/5))
		end
		if (RightLeg.FootTarget - RightRayPos).Magnitude > 0.7 then
			setupFootTween(RightLeg,RightRayPos,0.2*(Humanoid.HipHeight/5))
		end
	elseif not self.LeftForward then
		if (RightLeg.Planted and LeftLeg.Planted and math.abs(AvgAngle) >= 0) then
			setupFootTween(LeftLeg,LeftRayPos,TimeToReachRightRayPos/2)
			self.LeftForward = true
		end
	else
		if (LeftLeg.Planted and RightLeg.Planted and math.abs(AvgAngle) >= 0) then
			setupFootTween(RightLeg,RightRayPos,TimeToReachLeftRayPos/2)
			self.LeftForward = false
		end
	end
end

function LegAnimator:step(et,dt)
	-- Do the stuff!
	local LeftLeg = self.Legs.Left
	local RightLeg = self.Legs.Right

	local Rig = self.Rig
	local Root = self.Root
	local Torso = Rig:WaitForChild("Torso")
	local Humanoid = self.Humanoid

	local XZVel = (Root.Velocity*Vector3.new(1,0,1))
	local XZSpeed = XZVel.Magnitude

	local IsGrounded = (Humanoid.FloorMaterial ~= Enum.Material.Air)

	if IsGrounded then
		self:walkStep(XZVel)
		-- Tween feet to desired positions
		local LeftLegT = tick() - LeftLeg.StepStartTick
		local RightLegT = tick() - RightLeg.StepStartTick
		if LeftLegT < LeftLeg.StepTime then
			local MidPoint = LeftLeg.StepStart:Lerp(LeftLeg.FootTarget,0.5)
			LeftLeg.FootPos = bezierSolve(LeftLeg.StepStart,MidPoint + Vector3.new(0,Humanoid.HipHeight*2,0),LeftLeg.FootTarget,LeftLegT/LeftLeg.StepTime)
		else
			LeftLeg.FootPos = LeftLeg.FootTarget
			LeftLeg.Planted = true
		end

		if RightLegT < RightLeg.StepTime then
			local MidPoint = RightLeg.StepStart:Lerp(RightLeg.FootTarget,0.5)
			RightLeg.FootPos = bezierSolve(RightLeg.StepStart,MidPoint + Vector3.new(0,Humanoid.HipHeight*2,0),RightLeg.FootTarget,RightLegT/RightLeg.StepTime)
		else
			RightLeg.FootPos = RightLeg.FootTarget
			RightLeg.Planted = true
		end
	else
		LeftLeg.FootPos = LeftLeg.FootPos:Lerp((Torso.CFrame * CFrame.new(-0.5,-2.5,0.6)).p,0.7)
		RightLeg.FootPos = RightLeg.FootPos:Lerp((Torso.CFrame * CFrame.new(0.5,-2.5,0.6)).p,0.7)

		LeftLeg.StepStartTick = tick()
		RightLeg.StepStartTick = tick()

		LeftLeg.StepStart = LeftLeg.FootPos
		RightLeg.StepStart = RightLeg.FootPos
	end

	local LeftHipCF = Torso.CFrame * LeftLeg.OrigHipC0
	local LeftHipPlane, LeftHipAngle, LeftKneeAngle = solveIK(
		LeftHipCF, LeftLeg.FootPos,
		Rig.UpperLeftLeg.Size.Y-0.3, Rig.LowerLeftLeg.Size.Y
	)

	LeftLeg.Hip.C0 = Torso.CFrame:toObjectSpace(LeftHipPlane) * CFrame.Angles(LeftHipAngle, 0, 0)
	LeftLeg.Knee.C0 = LeftLeg.OrigKneeC0 * CFrame.Angles(LeftKneeAngle, 0, 0)

	local RightHipCF = Torso.CFrame * RightLeg.OrigHipC0
	local RightHipPlane, RightHipAngle, RightKneeAngle = solveIK(
		RightHipCF, RightLeg.FootPos,
		Rig.UpperRightLeg.Size.Y-0.3, Rig.LowerRightLeg.Size.Y
	)

	RightLeg.Hip.C0 = Torso.CFrame:toObjectSpace(RightHipPlane) * CFrame.Angles(RightHipAngle, 0, 0)
	RightLeg.Knee.C0 = RightLeg.OrigKneeC0 * CFrame.Angles(RightKneeAngle, 0, 0)


	local TargetC0CF = CFrame.fromAxisAngle(Vector3.new(0,0,1),Root.RotVelocity.Y/8)
	TargetC0CF = TargetC0CF * CFrame.fromAxisAngle(Vector3.new(1,0,0),XZSpeed/(Humanoid.WalkSpeed*4))
	local SinVal = math.sin((tick()*5)%(math.pi*2))
	if IsGrounded then
	TargetC0CF = TargetC0CF * CFrame.fromAxisAngle(Vector3.new(0,1,0),SinVal*(XZSpeed/(Humanoid.WalkSpeed*6)))
	end
	TargetC0CF = TargetC0CF * CFrame.new(0,SinVal*SinVal*-0.33*((XZSpeed+3)/Humanoid.WalkSpeed),0)
	if Torso:FindFirstChild("Root") then
		Torso.Root.C0 = Torso.Root.C0:lerp(TargetC0CF,0.08)
	end
end

return LegAnimator