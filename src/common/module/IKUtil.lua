local IKUtil = {}

-- https://devforum.roblox.com/t/r15-ik-foot-placement/68675/5
-- Author: WhoBloxedWho
function IKUtil.SolveIK(originCF, targetPos, l1, l2)	
	-- put our position into local space in regards to the originCF
	local localized = originCF:pointToObjectSpace(targetPos)

	-- this breaks if OriginCF and targetPos are at the same position
	local localizedUnit = localized.unit

	-- the distance to from originCF.p to targetPos
	local l3 = localized.magnitude

	-- build an axis of rotation for rolling the arm
	-- forwardV3 is Vector3.new(0, 0, -1)
	local axis = Vector3.new(0, 0, -1):Cross(localizedUnit)

	-- find the angle to rotate our plane at
	local angle = math.acos(-localizedUnit.Z)

	-- create a rotated plane to base the angles off of
	local planeCF = originCF * CFrame.fromAxisAngle(axis, angle)

	-- L3 is between the length of l1 and l2
	-- return an offset plane so that one part reaches the goal and "folded" angles
	if l3 < math.max(l2, l1) - math.min(l2, l1) then
		return planeCF * CFrame.new(0, 0,  math.max(l2, l1) - math.min(l2, l1) - l3), -math.pi/2, math.pi

	-- l3 is greater than both arm lengths
	-- return an offset plane so the arm reaches its goal and flat angles
	elseif l3 > l1 + l2 then
		return planeCF, math.pi/2, 0--* CFrame.new(0, 0, l1 + l2 - l3), math.pi/2, 0

	-- the lengths check out, do the law of cosines math and offset the plane to reach the targetPos
	-- return the offset plane, and the 2 angles for our "arm"
	else
		local a1 = -math.acos((-(l2 * l2) + (l1 * l1) + (l3 * l3)) / (2 * l1 * l3))
		local a2 = math.acos(((l2  * l2) - (l1 * l1) + (l3 * l3)) / (2 * l2 * l3))

		return planeCF, -a1 + math.pi/2, -a2 + a1
	end
end

return IKUtil