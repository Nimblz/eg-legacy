local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local component = script.Parent
local common_util = common:WaitForChild("util")

local getTextSize = require(common_util:WaitForChild("getTextSize"))

local Actions = require(common:WaitForChild("Actions"))
local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local ShopView = Roact.Component:extend("VersionLabel")

function ShopView:render()
    if self.props.view == "shop" then
        return Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5,0.5),
            Size = UDim2.new(0,600,0,400),
            Position = UDim2.new(0.5,0,0.5,0),

            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255,255,255),
        }, {
            Roact.createElement(ShadowedTextLabel, {
                Font = Enum.Font.Gotham,
                TextSize = 48,
                Text = "Shop WIP",
                TextStrokeColor3 = Color3.fromRGB(0,0,0),
                TextStrokeTransparency = 0,

                Size = UDim2.new(1,0,1,0),

                BackgroundTransparency = 1,
            })
        })
    end
end

local function mapDispatchToProps(dispatch)
    return {
        close = function()
            dispatch(Actions.UI_VIEW_SET(nil))
        end
    }
end

ShopView = RoactRodux.connect(nil,mapDispatchToProps)(ShopView)

return ShopView