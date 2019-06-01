local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- scaling constants
local TARGET_SCALE = 0.55
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

function changeView(viewId,props)
    props.menuButtonPressed(viewId,props)
end

local function newButton(viewId, name, props, layoutOrder, callback)
    local buttonText = name
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
        [Roact.Event.MouseButton1Click] = function() callback(viewId,props) end
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

local function homeButton()

end

function SideMenu:render()

    local touchEnabled = game:GetService("UserInputService").TouchEnabled

    local menuButtons = {
        inventoryButton = newButton("inventory", "Inventory",self.props,1,changeView),
        shopButton = newButton("shop", "Shop",self.props,2,changeView),
        devproductsButton = newButton("devproducts", "Buy Coins",self.props,3,changeView),
        settingsButton = newButton("settings", "Settings",self.props,4,changeView),
        homeButton = newButton("home", "Respawn",self.props,5,(function()
            LocalPlayer.Character.PrimaryPart.CFrame = workspace:WaitForChild("homewarp").CFrame
        end))
    }

    local pixelSize = 5*(64+PADDING)

    menuButtons.scale = Roact.createElement("UIScale", {
        Scale = math.min(1,(self.props.viewportSize.Y * TARGET_SCALE)/pixelSize)
    })

    menuButtons.layout = Roact.createElement("UIListLayout", {
        Padding = UDim.new(0,PADDING),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    })

    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(1,0.5),
        Size = UDim2.new(0,0,0,pixelSize),
        Position = UDim2.new(1,-PADDING,0.5,(touchEnabled and -32) or 0),

        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        ZIndex = 3
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