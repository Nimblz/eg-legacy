local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local component = script.Parent
local common_util = common:WaitForChild("util")

local getTextSize = require(common_util:WaitForChild("getTextSize"))

local Actions = require(common:WaitForChild("Actions"))
local VersionInfo = require(common:WaitForChild("VersionInfo"))
local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local VersionLabel = Roact.Component:extend("VersionLabel")

function VersionLabel:render()
    local currentVersion = VersionInfo:getCurrent()

    local versionText = ("Version: %s (%s)"):format(currentVersion.version,currentVersion.date)
    local labelSize = getTextSize(versionText,Enum.Font.Gotham,24)

    return Roact.createElement("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0,10,1,-10),
        AnchorPoint = Vector2.new(0,1),
        Size = UDim2.new(
            0,labelSize.X,
            0,labelSize.Y),
        Text = "",
        [Roact.Event.MouseButton1Click] = (function()
            self.props.onClick(self.props)
        end)
    },
    {
        Roact.createElement(ShadowedTextLabel, {
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 24,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextStrokeColor3 = Color3.fromRGB(0,0,0),
            TextStrokeTransparency = 0,
            Text = versionText,
            Size = UDim2.new(1,0,1,0),
        })
    })
end

local function mapDispatchToProps(dispatch)
    return {
        onClick = function(props)
            if props.view == "changelog" then
                print("gooh")
                dispatch(Actions.UI_VIEW_SET("nil"))
            else
                print("hooh")
                dispatch(Actions.UI_VIEW_SET("changelog")) -- :) u did it
            end
        end
    }
end

VersionLabel = RoactRodux.connect(nil,mapDispatchToProps)(VersionLabel)

return VersionLabel