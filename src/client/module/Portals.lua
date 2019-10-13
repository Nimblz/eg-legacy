local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Promise = require(lib:WaitForChild("Promise"))

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Selectors = require(common:WaitForChild("Selectors"))

local TELE_OFFSET = 7
local PORTAL_DEBOUNCE = 2.5

local Portals = PizzaAlpaca.GameModule:extend("Portals")

local portalsBin = Workspace:WaitForChild("portals")
local portals1 = portalsBin:WaitForChild("portals1")
local portals2 = portalsBin:WaitForChild("portals2")

local function teleport(whereTo)
	local Char = LocalPlayer.Character
	local Root = Char.PrimaryPart
	if Root then
		Root.CFrame = whereTo
	end
end

local function createPortal(homePortal,awayPortal,active,api)
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
				teleport(awayPortalTrigger.CFrame * CFrame.new(0,0,-TELE_OFFSET))
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
					teleport(homePortalTrigger.CFrame * CFrame.new(0,0,-TELE_OFFSET))
				end

				wait(PORTAL_DEBOUNCE)
				debounce = false
			end
		end
	end)
end

function Portals:postInit()
	local storeContainer = self.core:getModule("StoreContainer")
	local clientApi = self.core:getModule("ClientApi")

	Promise.all({
        storeContainer:getStore(),
        clientApi:getApi()
    }):andThen(function(resolved)
		return Promise.async(function(resolve,reject)
			local store, api = unpack(resolved)

			for _,awayPortal in pairs(portals2:GetChildren()) do
				local homePortal = portals1:FindFirstChild(awayPortal.Name)

				local state = store:getState() or {}
				local portalActive = Selectors.isPortalActive(state, LocalPlayer, awayPortal.name) or false

				createPortal(homePortal,awayPortal,portalActive, api)
			end

			resolve()
        end)
    end)
end

return Portals