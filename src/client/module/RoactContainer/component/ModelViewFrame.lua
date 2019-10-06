-- ez viewport

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")


local Dictionary = require(common:WaitForChild("Dictionary"))
local Roact = require(lib:WaitForChild("Roact"))

local ModelViewFrame = Roact.Component:extend("ModelViewFrame")

local function getCopy(model)
	if not model then return end
	local newCopy = model:Clone()
	newCopy.CFrame = CFrame.new(0,0,0)
	return newCopy
end

function ModelViewFrame:init(props)
    self.state = {
        modelCopy = getCopy(props.model),
		modelExtent = props.model.Size.Magnitude/2,
		thumbCamRef = Roact.createRef(),
		viewportRef = Roact.createRef(),
    }
end

function ModelViewFrame:didMount()
	local viewport = self.state.viewportRef.current
	local thumbCam = self.state.thumbCamRef.current

	viewport.CurrentCamera = thumbCam

	if not self.state.modelCopy then return end
	self.state.modelCopy.Parent = viewport
end

function ModelViewFrame:render()
    local thumbCamElement = Roact.createElement("Camera",{
        CFrame = CFrame.new(
            (Vector3.new(0.3,0.3,-1).Unit)*
            (self.state.modelExtent+4),
            Vector3.new(0,0,0)),
		FieldOfView = 45,
		[Roact.Ref] = self.state.thumbCamRef,
    })
    return Roact.createElement("ViewportFrame", {
		BackgroundTransparency = 1,
		ImageColor3 = self.props.ImageColor3,
		LayoutOrder = self.props.LayoutOrder or 0,
		Size = self.props.Size or UDim2.new(0,64,0,64),
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,
		[Roact.Ref] = self.state.viewportRef
	},
		Dictionary.merge(self.props[Roact.Children], {
			thumbCamElement,
		})
	)
end

return ModelViewFrame