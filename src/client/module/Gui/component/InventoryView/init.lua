local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local component = script.Parent

local Assets = require(common:WaitForChild("Assets"))
local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Actions = require(common:WaitForChild("Actions"))
local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local AssetGrid = require(component:WaitForChild("AssetGrid"))
local VerticalNavbar = require(component:WaitForChild("VerticalNavbar"))

local InventoryView = Roact.Component:extend("VersionLabel")

function InventoryView:setCatagory(newCatagory)
    self:setState({
        catagory = newCatagory,
    })
end

function InventoryView:init()
    self:setState({
        catagory = AssetCatagories.byId["hat"],
    })
end

function InventoryView:render()

    local cataButtons = AssetCatagories.all

    local inventory = self.props.inventory

    local catagoryAssets = {}

    for _, asset in pairs(Assets.all) do
        if asset.type == self.state.catagory.id then
            table.insert(catagoryAssets, asset.id)
        end
    end

    local content = {}
    content.padding = Roact.createElement("UIPadding", {
        PaddingLeft = UDim.new(0,16),
        PaddingTop = UDim.new(0,16),
        PaddingRight = UDim.new(0,16),
        PaddingBottom = UDim.new(0,16),
    })

    content.assetScrollFrame = Roact.createElement("ScrollingFrame", {
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = Color3.fromRGB(245,245,245),
    }, {
        assetGrid = Roact.createElement(AssetGrid, {
            containerProps = {
                Size = UDim2.new(1,0,1,0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
            },
            layoutProps = {
                CellSize = UDim2.new(0,128,0,128),
                CellPadding = UDim2.new(0,8,0,8),
            },
            paddingProps = {
                PaddingLeft = UDim.new(0,16),
                PaddingTop = UDim.new(0,16),
            },
            assets = catagoryAssets or {},
            assetElementProps = {
                onClick = function()
                    print("HOOH")
                end
            }
        })
    })

    return Roact.createElement("Frame", {
        Size = UDim2.new(0,800,0,600),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),

        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255,255,255)
    }, {
        layout = Roact.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Top,
        }),
        catagoriesNavbar = Roact.createElement(VerticalNavbar, {
            BackgroundColor3 = Color3.fromRGB(0, 145, 255),
            width = 64,
            navButtons = cataButtons,
            ZIndex = 2,
            selectedCatagory = self.state.catagory,
            onCatagorySelect = function(catagory)
                self:setCatagory(catagory)
            end,
        }),
        contentframe = Roact.createElement("Frame", {
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -64, 1, 0),
        }, content)
    })
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