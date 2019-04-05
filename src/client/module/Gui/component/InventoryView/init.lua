local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local component = script.Parent
local common_util = common:WaitForChild("util")

local getTextSize = require(common_util:WaitForChild("getTextSize"))

local Assets = require(common:WaitForChild("Assets"))
local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Actions = require(common:WaitForChild("Actions"))
local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local InventoryView = Roact.Component:extend("VersionLabel")

function InventoryView:render()

    local children = {}

    for _,asset in pairs(Assets.getAll()[AssetCatagories.getCatagory("hat")]) do
        children[asset.id] = Roact.createElement("TextLabel", {
            Text = asset.id
        })
    end

    children.layout = Roact.createElement("UIGridLayout", {
        CellSize = UDim2.new(0,92,0,92),
        CellPadding = UDim2.new(0,12,0,12),
    })

    if self.props.view == "inventory" then
        return Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5,0.5),
            Size = UDim2.new(0,600,0,400),
            Position = UDim2.new(0.5,0,0.5,0),

            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255,255,255),
        }, children)
    end
end

local function mapDispatchToProps(dispatch)
    return {
        close = function()
            dispatch(Actions.UI_VIEW_SET(nil))
        end
    }
end

InventoryView = RoactRodux.connect(nil,mapDispatchToProps)(InventoryView)

return InventoryView