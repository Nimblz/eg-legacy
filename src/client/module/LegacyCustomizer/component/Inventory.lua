local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(Lib:WaitForChild("Roact"))

local InventoryItem = require(script.Parent.InventoryItem)

return function(props)
	local HatItems = {}

	HatItems.Layout = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.new(0,5,0,5),
		CellSize = UDim2.new(0,64,0,64),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	for idx,hat in pairs(props.Hats) do
		HatItems[idx] = Roact.createElement(InventoryItem,{Name = hat.Name, Hat = hat, LayoutOrder = idx})
	end

	return Roact.createElement("ScrollingFrame", {
		Visible = props.Enabled,
		Size = UDim2.new(0,((64+5)*7) + 12,1/2,0),
		CanvasSize = UDim2.new(0,0,0,(64+5)*math.ceil(#props.Hats/7)),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1,
	}, HatItems)
end