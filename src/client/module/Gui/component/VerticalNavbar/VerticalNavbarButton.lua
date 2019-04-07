local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))

local VerticalNavbarButton = Roact.Component:extend("VerticalNavbarButton")

function VerticalNavbarButton:init(initialProps)
end

function VerticalNavbarButton:render()
    return Roact.createElement("ImageButton", {
        
    })
end

return VerticalNavbarButton