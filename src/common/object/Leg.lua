local Leg = {}

function Leg.new(rig,hip,knee)
	return setmetatable({
		Rig = rig,

		OrigHipC0 = hip.C0,
		OrigKneeC0 = knee.C0,

		FootPos = Vector3.new(0,0,0),
		FootTarget = Vector3.new(0,0,0),
		StepStart = Vector3.new(0,0,0),
		StepStartTick = tick(),
		StepTime = 0.2,

		Planted = true,

		OtherLeg = nil,

		Hip = hip,
		Knee = knee
	},{__index = Leg})
end

function Leg:setOtherLeg(otherleg)
	self.OtherLeg = otherleg

	return self
end

return Leg