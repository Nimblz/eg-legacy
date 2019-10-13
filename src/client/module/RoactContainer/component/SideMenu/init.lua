local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- scaling constants
local TARGET_SCALE = 1/15
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
local MenuButton = require(script:WaitForChild("MenuButton"))

local function changeView(viewId,props)
    props.menuButtonPressed(viewId,props)
end

local function newButton(viewId, image, name, props, layoutOrder, callback)
    return Roact.createElement(MenuButton,{
        viewId = viewId,
        image = image,
        parentProps = props,
        layoutOrder = layoutOrder,
        callback = callback,
        name = name
    })
end

function SideMenu:render()

    local touchEnabled = game:GetService("UserInputService").TouchEnabled

    local menuButtons = {
        inventoryButton = newButton("inventory", "rbxassetid://666448883", "Inventory",self.props,1,changeView),
        shopButton = newButton("shop", "rbxassetid://4102976956", "Item Shop",self.props,2,changeView),
        devproductsButton = newButton("devproducts", "rbxassetid://443085937", "Robux Shop",self.props,3,changeView),
        settingsButton = newButton("settings", "rbxassetid://282366832", "Settings",self.props,4,changeView),
        homeButton = newButton("home", "rbxassetid://414904019", "Respawn",self.props,5,(function()
            LocalPlayer.Character.PrimaryPart.CFrame = workspace:WaitForChild("homewarp").CFrame
        end))
    }

    local pixelSize = 64

    menuButtons.scale = Roact.createElement("UIScale", {
        Scale = math.min(1,(self.props.viewportSize.Y * TARGET_SCALE)/pixelSize)
    })

    menuButtons.layout = Roact.createElement("UIListLayout", {
        Padding = UDim.new(0,PADDING),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
    })

    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5,0),
        Size = UDim2.new(0,0,0,pixelSize),
        Position = UDim2.new(0.5,0,0,PADDING),

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