local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local component = script.Parent
local common_util = common:WaitForChild("util")

local getTextSize = require(common_util:WaitForChild("getTextSize"))

local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))

local Roact = require(lib:WaitForChild("Roact"))

return function(props)
    props.iconImage = props.iconImage or "rbxassetid://"
    props.statName = props.statName or "UNDEFINED"
    props.fontSize = props.fontSize or 36
    props.value = props.value or "UNDEFINED"
    props.font = props.font or Enum.Font.GothamBlack
    props.Size = props.Size or UDim2.new(0,400,0,64)
    props.Position = props.Position or UDim2.new(0,0,0.5,0)

    local statWidth = getTextSize(props.statName,props.font,props.fontSize)
    local valueWidth = getTextSize(props.value,props.font,props.fontSize)

    local children = {
        Roact.createElement("UIListLayout",{
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0,8),
        }),
        ShadowedTextLabel({
            Name = "nameLabel",
            Text = props.statName, -- :) <-- this is a smile, i hope it made you smile!
            BackgroundTransparency = 1,
            Font = props.font,
            TextSize = props.fontSize,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextStrokeTransparency = 0,
            Size = UDim2.new(props.Size.X.Scale,statWidth.X,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 1,
        }),
        ShadowedTextLabel({
            Name = "valueLabel",
            BackgroundTransparency = 1,
            Text = props.value,
            Font = props.font,
            TextSize = props.fontSize,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextStrokeTransparency = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(props.Size.X.Scale,valueWidth.X,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 2,
        }),
    }

    if props.iconImage then
        children.icon = Roact.createElement("ImageLabel", {
            Name = "iconLabel",
            BackgroundTransparency = 1,
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
        BackgroundTransparency = 1,
    }, children)
end