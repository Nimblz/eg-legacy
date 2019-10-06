local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Selectors = require(common:WaitForChild("Selectors"))

local TELE_OFFSET = 7
local PORTAL_DEBOUNCE = 2.5

local Portals = PizzaAlpaca.GameModule:extend("Portals")

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
				wait(0.1)
				Teleport(awayPortalTrigger.CFrame * CFrame.new(0,0,-TELE_OFFSET))
			end
			wait(PORTAL_DEBOUNCE)
			debounce = false
		end
	end)

	awayPortalTrigger.Touched:Connect( function(hit)
		if hit.Parent == LocalPlayer.Character then
			if not debounce then
				debounce = true
				wait(0.1)
				if not active then
					active = true
					homePortalTrigger.Transparency = 0.5
					awayPortalTrigger.Transparency = 0.5
					api:portalActivate(awayPortal.Name)
				else
					Teleport(homePortalTrigger.CFrame * CFrame.new(0,0,-TELE_OFFSET))
				end

				wait(PORTAL_DEBOUNCE)
				debounce = false
			end
		end
	end)
end

function Portals:start(client)
    for _,awayPortal in pairs(portals2:GetChildren()) do
        local homePortal = portals1:FindFirstChild(awayPortal.Name)

		local state = client.store:getState() or {}
		local portalActive = Selectors.isPortalActive(state, LocalPlayer, awayPortal.name) or false

        CreatePortal(homePortal,awayPortal,portalActive,client.api)
	end
end

return Portals