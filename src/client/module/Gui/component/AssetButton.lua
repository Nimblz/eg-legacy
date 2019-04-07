local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")
local component = script.Parent
local common_util = common:WaitForChild("util")

local Roact = require(lib:WaitForChild("Roact"))
local Assets = require(common:WaitForChild("Assets"))

local ModelViewFrame = require(component:WaitForChild("ModelViewFrame"))

local AssetButton = Roact.Component:extend("AssetButton")

function AssetButton:render()
    local asset = self.props.asset
    local children = {}

    local model = Assets.getModel(asset.id)
    if model then
        children.modelView = Roact.createElement(ModelViewFrame, {
            model = model,
            Size = UDim2.new(1,-16,1,-16),
            AnchorPoint = Vector2.new(0.5,0),
            Position = UDim2.new(0.5,0,0,8),
        })
    end
    if asset.thumbnailImage then
        children.thumbnail = Roact.createElement("ImageLabel", {
            Image = asset.thumbnailImage,
            Size = UDim2.new(1,0,1,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            BackgroundTransparency = 1,
            model = model
        })
    end
    if self.props.equipped then
        children.checkMark = Roact.createElement("ImageLabel", {
            Image = "rbxassetid://3039494338",
            BackgroundTransparency = 1,
            ImageColor3 = Color3.fromRGB(56, 206, 39),
            AnchorPoint = Vector2.new(1,1),
            Position = UDim2.new(1,4,1,4),
            Size = UDim2.new(0,32,0,32),
        })
    end

    return Roact.createElement("ImageButton", {
        Image = "rbxassetid://3039276724",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(15, 15, 17, 17),
        ImageColor3 = self.props.ImageColor3 or Color3.fromRGB(245,245,245),
		LayoutOrder = self.props.LayoutOrder or 0,
		Size = UDim2.new(0,64,0,64),
        BackgroundTransparency = 1,
    }, children)
end

return AssetButton