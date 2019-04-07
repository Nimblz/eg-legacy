local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remote = ReplicatedStorage:WaitForChild("remote")
local Lib = ReplicatedStorage:WaitForChild("lib")

local RequestHat = Remote:WaitForChild("RequestHat")

local Roact = require(Lib:WaitForChild("Roact"))

local InvItem = Roact.Component:extend("InventoryItem")

local function getCopy(hat)
	local newCopy = hat:Clone()
	newCopy.CFrame = CFrame.new(0,0,0)
	return newCopy
end

function InvItem:init(props)
	self.state = {
		hatCopy = getCopy(props.Hat),
		hatExtent = props.Hat.Size.Magnitude/2,
		thumbCamRef = Roact.createRef(),
		viewPortRef = Roact.createRef(),
	}
end

function InvItem:render()
	local thumbCamElement = Roact.createElement("Camera",{
		CFrame = CFrame.new((Vector3.new(0.3,0.3,-1).Unit)*(self.state.hatExtent+4),Vector3.new(0,0,0)),
		FieldOfView = 45,
		[Roact.Ref] = self.state.thumbCamRef,
	})

	return Roact.createElement("ImageButton", {
		Image = "rbxassetid://2823570525",
		LayoutOrder = self.props.LayoutOrder or 0,
		Size = UDim2.new(0,64,0,64),
		BackgroundTransparency = 1,
		ImageTransparency = 0.3,
		[Roact.Event.MouseButton1Click] = function(rbx)
			RequestHat:FireServer(self.props.Hat)
		end,
	}, {
		Roact.createElement("ViewportFrame", {
			Size = UDim2.new(1,0,1,0),
			BackgroundTransparency = 1,
			[Roact.Ref] = self.state.viewPortRef
		}, {
			thumbCamElement,
		})
	})
end

function InvItem:didMount()
	local viewPort = self.state.viewPortRef.current
	local thumbCam = self.state.thumbCamRef.current

	viewPort.CurrentCamera = thumbCam

	self.state.hatCopy.Parent = viewPort
end

return InvItem