local function equipHatToPlayer(player,hat)
	assert(hat and hat:IsA"BasePart" and hat:FindFirstChild("HatAttachment"), "Invalid hat.")

	local Character = player.Character
	if Character then

		local CurrentHat = Character:FindFirstChildOfClass("Accessory")

		if CurrentHat then CurrentHat:Destroy() end

		local Humanoid = Character:FindFirstChild("Humanoid")
		if Humanoid then
			local NewHandle = hat:Clone()

			local NewAccessory = Instance.new("Accessory")
			NewHandle.Name = "Handle"
			NewHandle.Anchored = false
			NewHandle.CanCollide = false
			NewHandle.Massless = true
			NewHandle.Parent = NewAccessory

			Humanoid:AddAccessory(NewAccessory)
		end
	end
end

return equipHatToPlayer