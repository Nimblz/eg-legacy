local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remote = ReplicatedStorage:WaitForChild("remote")
local Common = ReplicatedStorage:WaitForChild("common")
local Lib = ReplicatedStorage:WaitForChild("lib")

local RequestHat = Remote:WaitForChild("RequestHat")

local Roact = require(Lib:WaitForChild("Roact"))

return function(props)
	local Button = Roact.createElement("TextButton", {
		Text = " "..props.Name,
		Font = Enum.Font.GothamBlack,
		LayoutOrder = props.LayoutOrder or 0,
		Size = UDim2.new(1,0,0,24),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		
		[Roact.Event.MouseButton1Click] = function(rbx)
			RequestHat:FireServer(props.Hat)
		end,
	})
	
	return Button
end