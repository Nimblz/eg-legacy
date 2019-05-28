-- displays coins and other counters
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local util = common:WaitForChild("util")

local beautifyNumber = require(util:WaitForChild("beautifyNumber"))

local component = script

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))
local Selectors = require(common:WaitForChild("Selectors"))
local StatCounter = require(component:WaitForChild("StatCounter"))

local TARGET_AXIS_SCALE = 1/4
local PIXEL_SIZE = 300

local StatFrame = Roact.Component:extend("StatFrame")

function StatFrame:render()
    return Roact.createElement("Frame", {
        Name = "StatFrame",
        Position = UDim2.new(0,32,0.5,0),
        Size = UDim2.new(0,300,0,300),
        AnchorPoint = Vector2.new(0,0.5),
        BackgroundTransparency = 1,
    }, {
        scale = Roact.createElement("UIScale", {
            Scale = math.min(1,(self.props.viewportSize.X * TARGET_AXIS_SCALE)/PIXEL_SIZE)
        }),
        layout = Roact.createElement("UIListLayout",{
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),

        coinCounter = Roact.createElement(StatCounter,{
            iconImage = "rbxassetid://1025945542",
            statName = "Coins: ",
            value = beautifyNumber(self.props.coins,true)
        }),
    })
end

local function mapStateToProps(state,props)
    local stats = Selectors.getStats(state, LocalPlayer)
    return {
        coins = stats.coins
    }
end

StatFrame = RoactRodux.connect(mapStateToProps,nil)(StatFrame)

return StatFrame