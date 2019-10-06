local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))
local AssetCatagories = require(common:WaitForChild("AssetCatagories"))

local VerticalNavbarButton = require(script:WaitForChild("VerticalNavbarButton"))
local VerticalNavbar = Roact.Component:extend("VerticalNavbar")

function VerticalNavbar:init(initialProps)
end

function VerticalNavbar:render()

    local children = {}

    children.layout = Roact.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,0),
    })

    children.head = Roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 0, self.props.width),
        BackgroundColor3 = self.props.BackgroundColor3,
        BorderSizePixel = 0,
    }, {
        Roact.createElement("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),

            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,

            Rotation = 45,
        })
    })

    for idx, catagory in pairs(AssetCatagories.all) do
        children["cata_"..catagory.id] = Roact.createElement(VerticalNavbarButton, {
            BackgroundColor3 = self.props.BackgroundColor3,
            LayoutOrder = idx,
            tooltip = catagory.name,
            hoveredColor3 = self.props.hoveredColor3 or Color3.fromRGB(75, 183, 255),
            image = catagory.image,
            width = self.props.width,
            onClick = (function()
                self.props.onCatagorySelect(catagory)
            end),
            selected = self.props.selectedCatagory == catagory
        })
    end

    return Roact.createElement("Frame", {
        BackgroundColor3 = self.props.BackgroundColor3,
        BorderSizePixel = 0,
        Size = UDim2.new(0,self.props.width,1,0),
        ZIndex = self.props.ZIndex or 2,
    }, children)
end

return VerticalNavbar