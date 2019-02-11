local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remote = ReplicatedStorage:WaitForChild("remote")
local Common = ReplicatedStorage:WaitForChild("common")
local Lib = ReplicatedStorage:WaitForChild("lib")

local RequestColor = Remote:WaitForChild("RequestColor")

local Roact = require(Lib:WaitForChild("Roact"))

return function(props)
	local Colors = {}
	
	Colors.Layout = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.new(0,5,0,5),
		CellSize = UDim2.new(0,40,0,40),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	
	for idx,color in pairs(props.Colors) do
		Colors[idx] = Roact.createElement("TextButton", {
			BackgroundColor3 = color,
			Size = UDim2.new(0,40,0,40),
			BorderSizePixel = 0,
			Text = "",
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