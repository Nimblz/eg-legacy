local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(Lib:WaitForChild("Roact"))

local InventoryItem = require(script.Parent.InventoryItem)

return function(props)
	local HatItems = {}

	HatItems.Layout = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.new(0,5,0,5),
		CellSize = UDim2.new(0,200,0,24),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	for idx,hat in pairs(props.Hats) do
		HatItems[idx] = InventoryItem({Name = hat.Name, Hat = hat, LayoutOrder = idx})
	end

	return Roact.createElement("Frame", {
		Visible = props.Enabled,
		Size = UDim2.new(0,205*3,0,29*math.ceil(#props.Hats/3)),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1,
	}, HatItems)
end