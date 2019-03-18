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
    local shadowProps = shallowcopy(props) -- quick and dirty copy

    shadowProps.TextColor3 = Color3.fromRGB(0,0,0)
    shadowProps.Position = UDim2.new(0,2,0,1)
    shadowProps.AnchorPoint = Vector2.new(0,0)
    shadowProps.ZIndex = -1

    return Roact.createElement("TextLabel",props,{
        shadow = Roact.createElement("TextLabel", shadowProps)
    })
end