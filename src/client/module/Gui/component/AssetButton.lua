local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local component = script.Parent
local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local Selectors = require(common:WaitForChild("Selectors"))

local getAssetModel = require(common.util:WaitForChild("getAssetModel"))
local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local ModelViewFrame = require(component:WaitForChild("ModelViewFrame"))
local AssetButton = Roact.Component:extend("AssetButton")

function AssetButton:init(initialProps)
    self:setState( function() return {
        hovered = false,
    } end)
end

function AssetButton:render()
    local hovered = self.state.hovered
    local equipped = self.props.equipped
    local children = {}

    local checkmark
    if equipped then
        checkmark = Roact.createElement("ImageLabel", {
            Size = UDim2.new(0,24,0,24),

            AnchorPoint = Vector2.new(1,1),
            Position = UDim2.new(1,-4,1,-4),

            Image = "rbxassetid://2637717600",
            ImageColor3 = Color3.fromRGB(2, 183, 87),

            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BorderSizePixel = 0,
        })
    end

    children.padding = Roact.createElement("UIPadding", {
        PaddingLeft = UDim.new(0,8),
        PaddingTop = UDim.new(0,8),
        PaddingRight = UDim.new(0,8),
        PaddingBottom = UDim.new(0,8),
    })

    children.gamutGrid = Roact.createElement("ImageLabel", {
        Size = UDim2.new(1,0,1,0),
        Image = "rbxassetid://711821509",
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0,256,0,256),
        BorderColor3 = hovered and Color3.fromRGB(204, 204, 204) or Color3.fromRGB(230, 230, 230),
        ImageColor3 = Color3.fromRGB(223, 223, 223),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
    }, {
        viewport = Roact.createElement(ModelViewFrame, {
            model = getAssetModel(self.props.asset.id),
            Size = UDim2.new(1,0,1,0),
            ImageColor3 = self.props.blackout and Color3.new(0,0,0) or Color3.new(1,1,1)
        }, {
            isEquipped = checkmark
        })
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
        equipped = Selectors.isEquipped(state.gameState, LocalPlayer, props.asset.id)
    }
end

AssetButton = RoactRodux.connect(mapStateToProps,nil)(AssetButton)
return AssetButton