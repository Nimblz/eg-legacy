local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Portals = {}

local portalsBin = Workspace:WaitForChild("portals")
local portals1 = portalsBin:WaitForChild("portals1")
local portals2 = portalsBin:WaitForChild("portals2")

local function Teleport(whereTo)
	local Char = LocalPlayer.Character
	local Root = Char.PrimaryPart
	if Root then
		Root.CFrame = whereTo
	end
end

local function CreatePortal(homePortal,awayPortal,active,api)
	local homePortalTrigger = homePortal:FindFirstChild("PortalPart")
	local awayPortalTrigger = awayPortal:FindFirstChild("PortalPart")

	local debounce = false
	local active = active or false

	if active then
		homePortalTrigger.Transparency = 0.5
		awayPortalTrigger.Transparency = 0.5
	end

	homePortalTrigger.Touched:Connect( function(hit)
		if hit.Parent == LocalPlayer.Character then
			if not debounce and active then
				debounce = true
				Teleport(awayPortalTrigger.CFrame * CFrame.new(0,0,-5))
			end
			wait(0.5)
			debounce = false
		end
	end)

	awayPortalTrigger.Touched:Connect( function(hit)
		if hit.Parent == LocalPlayer.Character then
			if not debounce then
				debounce = true

				if not active then
					active = true
					homePortalTrigger.Transparency = 0.5
					awayPortalTrigger.Transparency = 0.5
					api:portalActivate(awayPortal.Name)
				else
					Teleport(homePortalTrigger.CFrame * CFrame.new(0,0,-5))
				end

				wait(0.5)
				debounce = false
			end
		end
	end)
end

function Portals:start(client)
    for _,awayPortal in pairs(portals2:GetChildren()) do
        local homePortal = portals1:FindFirstChild(awayPortal.Name)


		local state = client.store:getState().playerState or {}
		local portalActive = false

		if state and state.portals then
			portalActive = state.portals[awayPortal.Name] or false
		end

        CreatePortal(homePortal,awayPortal,portalActive,client.api)
	end
end

return Portals