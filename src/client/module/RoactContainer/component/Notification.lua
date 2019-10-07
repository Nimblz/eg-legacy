local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))

local Notification = Roact.Component:extend("Notification")

function Notification:init(initialProps)
end

function Notification:render()
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0,1),
        
        Size = UDim2.new(0,256,0,64)
    })
end

return Notification