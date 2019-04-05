local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- scaling constants
local PIXEL_WIDTH = 175
local TARGET_WIDTH_SCALE = 0.15

local PADDING = 16

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local component = script.Parent
local common_util = common:WaitForChild("util")

local getTextSize = require(common_util:WaitForChild("getTextSize"))

local Actions = require(common:WaitForChild("Actions"))
local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local SideMenu = Roact.Component:extend("VersionLabel")

local function capitalize(str)
    local firstLetter = str:sub(1,1)

    local rest = str:sub(2)

    return firstLetter:upper()..rest
end

local function newButton(name,props,layoutOrder)
    local buttonText = capitalize(name)
    return Roact.createElement("ImageButton", {
        Size = UDim2.new(
            0,getTextSize(buttonText,Enum.Font.GothamBlack,32).X + 2*PADDING,
            0,64),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        ImageTransparency = 1/3,
        Image = "rbxassetid://2823570525",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(75, 75, 76, 76),
        LayoutOrder = layoutOrder or 0,
        [Roact.Event.MouseButton1Click] = (function()
            props.menuButtonPressed(name,props)
        end)
    }, {
        Roact.createElement(ShadowedTextLabel,{
            Font = Enum.Font.GothamBlack,
            TextSize = 32,
            Text = buttonText,
            TextStrokeColor3 = Color3.fromRGB(0,0,0),
            TextStrokeTransparency = 0,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1,0,1,0),
            Position = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1,
        })
    })
end

function SideMenu:render()

    local touchEnabled = game:GetService("UserInputService").TouchEnabled

    local menuButtons = {
        inventoryButton = newButton("inventory",self.props,1),
        shopButton = newButton("shop",self.props,2),
        settingsButton = newButton("settings",self.props,3),
    }

    menuButtons.scale = Roact.createElement("UIScale", {
        Scale = (self.props.viewportSize.X * TARGET_WIDTH_SCALE)/PIXEL_WIDTH
    })

    menuButtons.layout = Roact.createElement("UIListLayout", {
        Padding = UDim.new(0,PADDING),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    })

    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(1,0.5),
        Size = UDim2.new(0,PIXEL_WIDTH,1,0),
        Position = UDim2.new(1,-PADDING,0.5,(touchEnabled and -32) or 0),

        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255,255,255),
    }, menuButtons)
end

local function mapDispatchToProps(dispatch)
    return {
        menuButtonPressed = function(viewName,props)
            if props.view == viewName then
                dispatch(Actions.UI_VIEW_SET(nil))
                return
            end
            dispatch(Actions.UI_VIEW_SET(viewName))
        end
    }
end

SideMenu = RoactRodux.connect(nil,mapDispatchToProps)(SideMenu)

return SideMenu