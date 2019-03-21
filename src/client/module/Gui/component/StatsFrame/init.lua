-- displays coins and other counters
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local component = script

local Roact = require(lib:WaitForChild("Roact"))
local StatCounter = require(component:WaitForChild("StatCounter"))

return function(props)
    return Roact.createElement("Frame", {
        Name = "StatFrame",
        Position = UDim2.new(0,32,0.5,0),
        Size = UDim2.new(0,400,0,200),
        AnchorPoint = Vector2.new(0,0.5),
        BackgroundTransparency = 1,
    }, {
        layout = Roact.createElement("UIListLayout",{
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),

        coinCounter = Roact.createElement(StatCounter,{
            iconImage = "rbxassetid://1025945542",
            statName = "Coins: ",
            value = props.coins
        }),
    })
end