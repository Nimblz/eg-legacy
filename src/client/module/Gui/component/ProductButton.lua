local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local component = script.Parent
local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local Selectors = require(common:WaitForChild("Selectors"))
local ShopProducts = require(common:WaitForChild("ShopProducts"))

local getAssetModel = require(common.util:WaitForChild("getAssetModel"))
local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local ModelViewFrame = require(component:WaitForChild("ModelViewFrame"))
local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))
local ProductButton = Roact.Component:extend("ProductButton")

function ProductButton:init(initialProps)
    self:setState( function() return {
        hovered = false,
    } end)
end

function ProductButton:render()
    local hovered = self.state.hovered
    local owned = self.props.owned
    local children = {}
    local checkmark
    local asset = self.props.asset
    if not asset then error("Asset not supplied to AssetButton element!") end

    local product = ShopProducts.byId[asset.id]
    local assetModel = getAssetModel(asset.id)
    if not assetModel then warn(("Asset [%s] has no model."):format(self.props.asset.id)) end

    if owned then
        checkmark = Roact.createElement("ImageLabel", {
            Size = UDim2.new(0,24,0,24),

            AnchorPoint = Vector2.new(1,1),
            Position = UDim2.new(1,-4,1,-4),

            Image = "rbxassetid://2637717600",
            ImageColor3 = Color3.fromRGB(2, 183, 87),

            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BorderSizePixel = 0,
            ZIndex = 3,
        })
    end

    local modifiers = {}

    modifiers.listLayout = Roact.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0,4),
    })

    if (asset.metadata or {}).isRainbow then
        modifiers.rainbow = Roact.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://3213669223",
            Size = UDim2.new(0,16,0,16),
        })
    end

    local modifiersFrame = Roact.createElement("Frame",{
        BackgroundTransparency = 1,
        Size = UDim2.new(1,-8,0,16),
        Position = UDim2.new(1,-4,0,4),
        AnchorPoint = Vector2.new(1,0),
    }, modifiers)

    children.layout = Roact.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    })

    children.padding = Roact.createElement("UIPadding", {
        PaddingLeft = UDim.new(0,8),
        PaddingTop = UDim.new(0,8),
        PaddingRight = UDim.new(0,8),
        PaddingBottom = UDim.new(0,8),
    })

    children.buyLabel = Roact.createElement("TextLabel", {
        Font = Enum.Font.GothamBlack,
        BackgroundColor3 = (owned and Color3.fromRGB(95, 95, 95)) or (hovered and Color3.fromRGB(0, 131, 43) or Color3.fromRGB(2, 183, 87)),
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,0,32),
        Text = owned and "Owned" or "Buy",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 24,
        LayoutOrder = 2
    })

    children.gamutGrid = Roact.createElement("ImageLabel", {
        Size = UDim2.new(1,0,1,0),
        Image = "rbxassetid://711821509",
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0,256,0,256),
        BorderColor3 = hovered and Color3.fromRGB(204, 204, 204) or Color3.fromRGB(230, 230, 230),
        BorderSizePixel = 0,
        ImageColor3 = Color3.fromRGB(223, 223, 223),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        LayoutOrder = 1
    }, {
        aspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Width,
            AspectType = Enum.AspectType.FitWithinMaxSize,
        }),
        viewport = Roact.createElement(ModelViewFrame, {
            model = assetModel,
            Size = UDim2.new(1,0,1,0),
            ImageColor3 = self.props.blackout and Color3.new(0,0,0) or Color3.new(1,1,1)
        }),
        isEquipped = checkmark,
        modifiers = modifiersFrame,
        price = Roact.createElement(ShadowedTextLabel, {
            Font = Enum.Font.GothamBlack,
            Text = "$"..tostring(product.price or "PRICE N/A"),
            TextSize = 24,
            TextStrokeTransparency = 0,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0,1),
            Position = UDim2.new(0,0,1,0),
            Size = UDim2.new(1,0,0,24),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom,
        }),
    })
    return Roact.createElement("TextButton", {
        BackgroundColor3 = hovered and Color3.fromRGB(223, 223, 223) or Color3.fromRGB(255,255,255),
        BorderColor3 = hovered and Color3.fromRGB(204, 204, 204) or Color3.fromRGB(230, 230, 230),
        AutoButtonColor = false,
        LayoutOrder = self.props.LayoutOrder or 0,
        Text = "",
        [Roact.Event.MouseButton1Click] = function()
            self.props.onClick(self.props.asset.id,self.props.equipped)
        end,

        [Roact.Event.MouseEnter] = function()
            self:setState( function() return {
                hovered = true,
            } end)
        end,

        [Roact.Event.MouseLeave] = function()
            self:setState( function() return {
                hovered = false,
            } end)
        end,
    }, children)
end

local function mapStateToProps(state, props)
    return {
        owned = Selectors.isOwned(state, LocalPlayer, props.asset.id)
    }
end

ProductButton = RoactRodux.connect(mapStateToProps,nil)(ProductButton)
return ProductButton