local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Signal = require(lib:WaitForChild("Signal"))

local PortalsListener = PizzaAlpaca.GameModule:extend("PortalsListener")
PortalsListener.portalActivated = Signal.new()

function PortalsListener:portalActivate(player,portalName)
    PortalsListener.portalActivated:fire(player,portalName)
end

return PortalsListener