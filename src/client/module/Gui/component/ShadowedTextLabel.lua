local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return function(props)

    local textProps = shallowcopy(props)

    textProps.Position = UDim2.new(0,0,0,0)
    textProps.Size = UDim2.new(1,0,1,0)
    textProps.AnchorPoint = Vector2.new(0,0)
    textProps.TextColor3 = textProps.TextColor3 or Color3.fromRGB(255,255,255)
    textProps.ZIndex = 2

    local shadowProps = shallowcopy(props) -- quick and dirty copy

    shadowProps.TextColor3 = Color3.fromRGB(0,0,0)
    shadowProps.Position = UDim2.new(0,2,0,1)
    shadowProps.ZIndex = 1

    local textLabel = Roact.createElement("TextLabel", textProps)
    local shadowLabel = Roact.createElement("TextLabel", shadowProps)

    return Roact.createElement("Frame",{
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        Size = props.Size,
        BackgroundTransparency = 1,
        LayoutOrder = props.LayoutOrder
    },{
        textLabel,
        shadowLabel,
    })
end