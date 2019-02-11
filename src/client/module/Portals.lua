local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Portals = {}

local World = Workspace:WaitForChild("staticworld")
local PortalsBin = World:WaitForChild("Portals")
local Portals1 = PortalsBin:WaitForChild("Portals1")
local Portals2 = PortalsBin:WaitForChild("Portals2")

local function Teleport(whereTo)
	local Char = LocalPlayer.Character
	local Root = Char.PrimaryPart
	if Root then
		Root.CFrame = whereTo
	end
end

local function CreatePortal(part1,part2)
	local Debounce = false
	local Active = false

	part1.Touched:Connect(function(hit)
		if hit.Parent == LocalPlayer.Character then
			if not Debounce and Active then
				Debounce = true
					Teleport(part2.CFrame * CFrame.new(0,0,-2))
			end
		wait(0.5)
		Debounce = false
		end
	end)

	part2.Touched:Connect(function(hit)
		if hit.Parent == LocalPlayer.Character then
			if not Debounce then
				Debounce = true

				if not Active then
					Active = true
					part1.Transparency = 0.5
					part2.Transparency = 0.5
				else
					Teleport(part1.CFrame * CFrame.new(0,0,-2))
				end

				wait(0.5)
				Debounce = false
			end
		end
	end)
end

function Portals:init()
    for _,awayPortal in pairs(Portals2:GetChildren()) do
        local HomePortal = Portals1:FindFirstChild(awayPortal.Name)

        local HomePortalTrigger = HomePortal:FindFirstChild("PortalPart")
        local AwayPortalTrigger = awayPortal:FindFirstChild("PortalPart")

        CreatePortal(HomePortalTrigger,AwayPortalTrigger)
	end
end

return Portals