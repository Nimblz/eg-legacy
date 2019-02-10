-- Todo: Refactor E V E R Y T H A N G

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local object = common:WaitForChild("object")
local util = common:WaitForChild("util")

local IKUtil = require(util:WaitForChild("IKUtil"))
local Leg = require(object:WaitForChild("Leg"))

local STEP_TIME = 0.2 -- Time in secs
local DOWN = Vector3.new(0,-1,0)

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

		LeftForward = false,

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

function LegAnimator:walkStep(XZVel)

	local LeftLeg = self.Legs.Left
	local RightLeg = self.Legs.Right

	local Rig = self.Rig
	local Root = self.Root
	local Humanoid = self.Humanoid

	local StepVec = ((XZVel / Humanoid.WalkSpeed) * 4)
	local ComparePos = (XZVel/Humanoid.WalkSpeed) * 1.5
	local LeftFootRayOrigin = (Root.CFrame * CFrame.new(-0.5,0,0)).p + StepVec + ComparePos
	local RightFootRayOrigin = (Root.CFrame * CFrame.new(0.5,0,0)).p + StepVec + ComparePos

	local LeftFootRay = Ray.new(LeftFootRayOrigin,DOWN*6)
	local RightFootRay = Ray.new(RightFootRayOrigin,DOWN*6)

	local LeftRayHit,LeftRayPos,LeftRayNormal = workspace:FindPartOnRayWithIgnoreList(LeftFootRay,{Rig})
	local RightRayHit,RightRayPos,RightRayNormal = workspace:FindPartOnRayWithIgnoreList(RightFootRay,{Rig})


	local LeftFootAngle = XZVel.Unit:Dot((LeftLeg.FootTarget - (Root.Position + ComparePos)).Unit)
	local RightFootAngle = XZVel.Unit:Dot((RightLeg.FootTarget - (Root.Position + ComparePos)).Unit)

	if self.LeftForward then
		if LeftFootAngle < 0 or (RightRayPos-RightLeg.FootTarget).Magnitude > 10 or (XZVel.Magnitude < 0.05 and (RightRayPos-RightLeg.FootTarget).Magnitude > 0.5) then
			self.LeftForward = false
			RightLeg.StepStartTick = tick()
			RightLeg.StepStart = RightLeg.FootPos
			RightLeg.FootTarget = RightRayPos
			LeftLeg.Planted = false
		end
	else
		if RightFootAngle < 0 or (LeftRayPos-LeftLeg.FootTarget).Magnitude > 10 or (XZVel.Magnitude < 0.05 and (LeftRayPos-LeftLeg.FootTarget).Magnitude > 0.5)  then
			self.LeftForward = true
			LeftLeg.StepStartTick = tick()
			LeftLeg.StepStart = LeftLeg.FootPos
			LeftLeg.FootTarget = LeftRayPos
			LeftLeg.Planted = false
		end
	end
end

function LegAnimator:step(et,dt)
	-- Do the stuff!

	local LeftLeg = self.Legs.Left
	local RightLeg = self.Legs.Right

	local Rig = self.Rig
	local Root = self.Root
	local Humanoid = self.Humanoid

	local XZVel = (Root.Velocity*Vector3.new(1,0,1))
	local XZSpeed = XZVel.Magnitude

	local IsGrounded = (Humanoid.FloorMaterial ~= Enum.Material.Air)

	if IsGrounded then
		self:walkStep(XZVel)
		-- Tween feet to desired positions
		local LeftLegT = tick() - LeftLeg.StepStartTick
		local RightLegT = tick() - RightLeg.StepStartTick
		if LeftLegT < STEP_TIME then
			local MidPoint = LeftLeg.StepStart:Lerp(LeftLeg.FootTarget,0.5)
			LeftLeg.FootPos = bezierSolve(LeftLeg.StepStart,MidPoint + Vector3.new(0,4,0),LeftLeg.FootTarget,LeftLegT/STEP_TIME)
		else
			LeftLeg.FootPos = LeftLeg.FootTarget
			LeftLeg.Planted = true
		end

		if RightLegT < STEP_TIME then
			local MidPoint = RightLeg.StepStart:Lerp(RightLeg.FootTarget,0.5)
			RightLeg.FootPos = bezierSolve(RightLeg.StepStart,MidPoint + Vector3.new(0,4,0),RightLeg.FootTarget,RightLegT/STEP_TIME)
		else
			RightLeg.FootPos = RightLeg.FootTarget
		end
	else
		LeftLeg.FootPos = LeftLeg.FootPos:Lerp((Rig.Torso.CFrame * CFrame.new(-0.5,-2.5,0.6)).p,0.7)
		RightLeg.FootPos = RightLeg.FootPos:Lerp((Rig.Torso.CFrame * CFrame.new(0.5,-2.5,0.6)).p,0.7)

		LeftLeg.StepStartTick = tick()
		RightLeg.StepStartTick = tick()

		LeftLeg.StepStart = LeftLeg.FootPos
		RightLeg.StepStart = RightLeg.FootPos
	end

	local LeftHipCF = Rig.Torso.CFrame * LeftLeg.OrigHipC0
	local LeftHipPlane, LeftHipAngle, LeftKneeAngle = IKUtil.solveIK(LeftHipCF, LeftLeg.FootPos, 1.4, 1.4)

	LeftLeg.Hip.C0 = Rig.Torso.CFrame:toObjectSpace(LeftHipPlane) * CFrame.Angles(LeftHipAngle, 0, 0)
	LeftLeg.Knee.C0 = LeftLeg.OrigKneeC0 * CFrame.Angles(LeftKneeAngle, 0, 0)

	local RightHipCF = Rig.Torso.CFrame * RightLeg.OrigHipC0
	local RightHipPlane, RightHipAngle, RightKneeAngle = IKUtil.solveIK(RightHipCF, RightLeg.FootPos, 1.4, 1.4)

	RightLeg.Hip.C0 = Rig.Torso.CFrame:toObjectSpace(RightHipPlane) * CFrame.Angles(RightHipAngle, 0, 0)
	RightLeg.Knee.C0 = RightLeg.OrigKneeC0 * CFrame.Angles(RightKneeAngle, 0, 0)


	local TargetC0CF = CFrame.fromAxisAngle(Vector3.new(0,0,1),Root.RotVelocity.Y/8)
	TargetC0CF = TargetC0CF * CFrame.fromAxisAngle(Vector3.new(1,0,0),XZSpeed/(Humanoid.WalkSpeed*4))
	local SinVal = math.sin((tick()*5)%(math.pi*2))
	if IsGrounded then
	TargetC0CF = TargetC0CF * CFrame.fromAxisAngle(Vector3.new(0,1,0),SinVal*(XZSpeed/(Humanoid.WalkSpeed*6)))
	end
	TargetC0CF = TargetC0CF * CFrame.new(0,SinVal*SinVal*-0.33*((XZSpeed+3)/Humanoid.WalkSpeed),0)
	Rig.Torso.Root.C0 = Rig.Torso.Root.C0:lerp(TargetC0CF,0.08)
end

return LegAnimator