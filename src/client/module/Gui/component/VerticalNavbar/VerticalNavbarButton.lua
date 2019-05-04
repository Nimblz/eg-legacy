local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))

local VerticalNavbarButton = Roact.Component:extend("VerticalNavbarButton")

function VerticalNavbarButton:init(initialProps)
    self:setState(function()
        return {
            hovered = false,
        }
    end)
end

function VerticalNavbarButton:render()

    local children = {}
    local active = (self.state.hovered or self.props.selected)

    children.thumb = Roact.createElement("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Image = self.props.image,

        BackgroundColor3 = (active and self.props.hoveredColor3) or self.props.BackgroundColor3,
        BorderColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    })

    if active then
        children.tooltip = Roact.createElement("ImageLabel", {
            Size = UDim2.new(0, 112, 0, 32),
            Position = UDim2.new(0, -8, 0.5, 0),
            AnchorPoint = Vector2.new(1,0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://2823570525",
            SliceCenter = Rect.new(75,75,75,75),
            ScaleType = Enum.ScaleType.Slice,
        }, {
            text = Roact.createElement("TextLabel", {
                Text = self.props.tooltip,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1 ,0),

                Font = Enum.Font.GothamSemibold,
                TextSize = 18,
            })
        })
    end

    return Roact.createElement("ImageButton", {
        Size = UDim2.new(1, (active and 8 or 0), 0, self.props.width),
        BackgroundColor3 = (active and self.props.hoveredColor3) or self.props.BackgroundColor3,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Modal = true,

        [Roact.Event.MouseEnter] = function()
            self:setState({
                hovered = true,
            })
        end,

        [Roact.Event.MouseLeave] = function()
            self:setState({
                hovered = false,
            })
        end,

        [Roact.Event.MouseButton1Click] = function()
            if self.props.onClick then
                self.props.onClick()
            end
        end,

        LayoutOrder = self.props.LayoutOrder,
    }, children)
end

return VerticalNavbarButton