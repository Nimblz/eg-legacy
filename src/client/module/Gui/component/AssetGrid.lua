local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local component = script.Parent

local Roact = require(lib:WaitForChild("Roact"))

local AssetButton = require(component:WaitForChild("AssetButton"))

local AssetGrid = Roact.Component:extend("AssetGrid")

function AssetGrid:render()
    local assetButtons = {}

    for idx,asset in pairs(self.props.assets or {}) do

        print(asset.id,idx,asset.rarity)
        assetButtons[asset.id] = Roact.createElement(AssetButton, {
            LayoutOrder = idx,
            asset = asset,
        })
    end

    assetButtons.layout = Roact.createElement("UIGridLayout", {
        CellSize = UDim2.new(0,self.props.CellSize.X,0,self.props.CellSize.Y),
        CellPadding = UDim2.new(0,self.props.CellPadding.X,0,self.props.CellPadding.Y),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local width =
        self.props.widthInCells *
        (self.props.CellSize.X + self.props.CellPadding.X)
    local height =
        math.ceil(#self.props.assets/self.props.widthInCells) *
        (self.props.CellSize.Y + self.props.CellPadding.Y)

    return Roact.createElement("Frame", {
        Size = UDim2.new(0,width,0,height),
        Position = self.props.Position,
        AnchorPoint = self.props.AnchorPoint,
        BackgroundTransparency = 1,
    },assetButtons)
end

return AssetGrid