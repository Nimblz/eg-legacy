local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Selectors = require(common:WaitForChild("Selectors"))
local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local MenuButton = Roact.Component:extend("MenuButton")

function MenuButton:init()
    self:setState(function(state)
        return {
            hovered = false
        }
    end)
end

function MenuButton:setHovered(bool)
    self:setState(function(state)
        return {
            hovered = bool
        }
    end)
end

function MenuButton:render()
    return Roact.createElement("ImageButton", {
        Size = UDim2.new(0,80,0,80),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        Image = "rbxassetid://4103149690",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(16, 16, 16, 16),
        LayoutOrder = self.props.layoutOrder or 0,
        [Roact.Event.MouseButton1Click] = function() self.props.callback(self.props.viewId,self.props.parentProps) end,
        [Roact.Event.MouseEnter] = function()
            self:setHovered(true)
        end,
        [Roact.Event.MouseLeave] = function()
            self:setHovered(false)
        end,
    }, {
        icon = Roact.createElement("ImageLabel", {
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0,64,0,64),
            BackgroundTransparency = 1,
            Image = self.props.image or "rbxassetid://4102976956",
            ImageColor3 = Color3.new(0,0,0),
        }),
        label = (self.state.hovered or self.props.viewActive) and Roact.createElement("ImageLabel", {
            AnchorPoint = Vector2.new(0.5,0),
            Position = UDim2.new(0.5,0,1,8),
            Size = UDim2.new(0,128,0,32),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            Image = "rbxassetid://4103149690",
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(16, 16, 16, 16),
        }, {
            text = Roact.createElement("TextLabel", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text = self.props.name,
                Font = Enum.Font.GothamBlack,
                TextSize = 16
            })
        })
    })
end

local function mapStateToProps(state,props)
    return {
        viewActive = Selectors.getUIView(state) == props.viewId
    }
end

MenuButton = RoactRodux.connect(mapStateToProps,nil)(MenuButton)

return MenuButton