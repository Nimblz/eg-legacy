local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))

local VerticalNavbar = Roact.Component:extend("VerticalNavbar")

function VerticalNavbar:init(initialProps)
end

function VerticalNavbar:render()

    local children = {}

    children.layout = Roact.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    children.head = Roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 0, self.props.width),
        BackgroundColor3 = self.props.BackgroundColor3,
        BorderSizePixel = 0,
    }, {
        Roact.createElement("Frame", {
            Size = UDim2.new(1/4, 0, 1/4, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),

            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,

            Rotation = 45,
        })
    })

    return Roact.createElement("Frame", {
        BackgroundColor3 = self.props.BackgroundColor3,
        BorderSizePixel = 0,
        Size = UDim2.new(0,self.props.width,1,0),
    }, children)
end

return VerticalNavbar