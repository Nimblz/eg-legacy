local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remote = ReplicatedStorage:WaitForChild("remote")
local Lib = ReplicatedStorage:WaitForChild("lib")

local RequestColor = Remote:WaitForChild("RequestColor")

local Roact = require(Lib:WaitForChild("Roact"))

return function(props)
    local Colors = {}

	Colors.Layout = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.new(0,5,0,5),
		CellSize = UDim2.new(0,40,0,40),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})

	for idx,color in pairs(props.Colors) do
		Colors[idx] = Roact.createElement("ImageButton", {
			Image = "rbxassetid://2885943902",
			ImageColor3 = color,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0,40,0,40),
			[Roact.Event.MouseButton1Click] = function(rbx)
				RequestColor:FireServer(color)
			end,
		})
	end

	return Roact.createElement("Frame", {
		Visible = props.Enabled,
		Size = UDim2.new(0,45*12,0,math.ceil(#props.Colors/12)),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(0.5,0,0.5,0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1,
	}, Colors)
end