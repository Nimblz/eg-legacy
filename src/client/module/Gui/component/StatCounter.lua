local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local common_util = common:WaitForChild("util")

local getTextSize = require(common_util:WaitForChild("getTextSize"))

local Roact = require(lib:WaitForChild("Roact"))

return function(props)
    props.iconImage = props.iconImage or "rbxassetid://"
    props.statName = props.statName or "UNDEFINED"
    props.fontSize = props.fontSize or 24
    props.value = props.value or "UNDEFINED"
    props.font = props.font or Enum.Font.GothamBlack
    props.Size = props.Size or UDim2.new(0,400,0,40)
    props.Position = props.Position or UDim2.new(0,0,0.5,0)

    local statWidth = getTextSize(props.statName,props.font,props.fontSize)
    local valueWidth = getTextSize(props.statName,props.font,props.fontSize)

    local children = {
        Roact.createElement("UIListLayout",{
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }),
        Roact.createElement("TextLabel",{
            Text = props.statName, -- :) <-- this is a smile, i hope it made you smile!
            Font = props.font,
            TextSize = props.fontSize,
            Size = UDim2.new(props.Size.X.Scale,statWidth.X,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 1,
        }),
        Roact.createElement("TextLabel",{
            Text = props.value,
            Font = props.font,
            TextSize = props.fontSize,
            Size = UDim2.new(props.Size.X.Scale,valueWidth.X,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 2,
        }),
    }

    if props.iconImage then
        children.icon = Roact.createElement("ImageLabel", {
            Name = "iconLabel",
            Image = props.iconImage,
            Size = UDim2.new(props.Size.X.Scale,props.Size.Y.Offset,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 0,
        })
    end

    return Roact.createElement("Frame",{
        Name = "counterFrame",
        AnchorPoint = Vector2.new(0,0.5),
        Size = props.Size,
        Position = props.Position,
    }, children)
end