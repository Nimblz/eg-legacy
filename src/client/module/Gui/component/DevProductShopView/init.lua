local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local component = script.Parent

local DevProducts = require(common:WaitForChild("DevProducts"))
local Actions = require(common:WaitForChild("Actions"))
local Roact = require(lib:WaitForChild("Roact"))

local PIXEL_SIZE = 600
local TARGET_AXIS_SCALE = 3/4

local DevProductShopView = Roact.Component:extend("DevProductShopView")

function DevProductShopView:render()
    local content = {}
    local productButtons = {}

    for _,product in pairs(DevProducts.all) do
        productButtons[product.id] = Roact.createElement("TextButton", {
            Text = product.name,
            TextColor3 = Color3.new(1,1,1),
            BackgroundColor3 = Color3.fromRGB(2, 183, 87),
            BorderSizePixel = 0,
            TextSize = 24,
            Font = Enum.Font.GothamBlack,
            TextWrapped = true,
            LayoutOrder = product.order,

            [Roact.Event.MouseButton1Click] = function()
                self.props.clientApi:buyDevproduct(product.id)
            end,
        })
    end

    productButtons.gridLayout = Roact.createElement("UIGridLayout", {
        CellPadding = UDim2.new(0,16,0,16),
        CellSize = UDim2.new(0,192,0,64),
        FillDirectionMaxCells = 3,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })


    content.padding = Roact.createElement("UIPadding", {
        PaddingLeft = UDim.new(0,16),
        PaddingTop = UDim.new(0,16),
        PaddingRight = UDim.new(0,16),
        PaddingBottom = UDim.new(0,16),
    })
    content.listLayout = Roact.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0,16),
    })
    content.scale = Roact.createElement("UIScale", {
        Scale = math.min(1,(self.props.viewportSize.Y * TARGET_AXIS_SCALE)/PIXEL_SIZE)
    })

    content.header = Roact.createElement("TextLabel",{
        Font = Enum.Font.GothamBlack,
        Text = "Buy Coins",
        TextScaled = true,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,64),
        LayoutOrder = 1,
    })

    content.buttonFrame = Roact.createElement("Frame", {
        Size = UDim2.new(1,0,1,-96),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
    }, productButtons)

    return Roact.createElement("Frame", {
        Size = UDim2.new(0,700,0,450),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),

        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255,255,255)
    }, content)
end

return DevProductShopView