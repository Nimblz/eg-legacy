-- dont look im indecent!

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local component = script.Parent.Parent
local common_util = common:WaitForChild("util")

local getTextSize = require(common_util:WaitForChild("getTextSize"))

local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))

local Roact = require(lib:WaitForChild("Roact"))
local Otter = require(lib:WaitForChild("Otter"))

local StatCounter = Roact.Component:extend("StatCounter")

function StatCounter:init()
    self:setState({
        iconRotation = 0,
        scale = 1,
        yOffset = 0,
        xOffset = 0,
    })
end

function StatCounter:didMount()
    -- animator, find a way to factor this kinda thing into a wrapper component?
    self.springus = Otter.createGroupMotor({rotation = 0, scale = 1,yOffset = 0,xOffset = 0})
    self.springus:onStep(function(values)
        self:setState({
            iconRotation = values.rotation,
            scale = values.scale,
            yOffset = values.yOffset,
            xOffset = values.xOffset,
        })
    end)
end

function StatCounter:sproing()
    self.springus:stop()
    self.springus.__states.rotation.velocity = math.random(600,700) * (math.random(0,1)*2 - 1)
    self.springus.__states.scale.velocity = 5
    self.springus.__states.yOffset.velocity = math.random(-300,-100)
    self.springus.__states.xOffset.velocity = math.random(50,200) * (math.random(0,1)*2 - 1)
    self.springus:setGoal({
        rotation = Otter.spring(0, {dampingRatio = 0.1, frequency = 4}),
        scale = Otter.spring(1, {dampingRatio = 0.15, frequency = 4}),
        yOffset = Otter.spring(0, {dampingRatio = 0.15, frequency = 3}),
        xOffset = Otter.spring(0, {dampingRatio = 0.15, frequency = 3}),
    })
    self.springus:start()
end

function StatCounter:didUpdate(prevProps,prevState)
    if self.props.value ~= prevProps.value then
        self:sproing()
    end
end

function StatCounter:render()
    local props = self.props
    props.iconImage = props.iconImage or "rbxassetid://"
    props.statName = props.statName or "UNDEFINED"
    props.fontSize = props.fontSize or 36
    props.value = props.value or "UNDEFINED"
    props.font = props.font or Enum.Font.GothamBlack
    props.Size = props.Size or UDim2.new(0,400,0,64)
    props.Position = props.Position or UDim2.new(0,0,0.5,0)

    local statWidth = getTextSize(props.statName,props.font,props.fontSize)
    local valueWidth = getTextSize(props.value,props.font,props.fontSize)

    local children = {
        layout = Roact.createElement("UIListLayout",{
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0,8),
        }),
        nameLabel = ShadowedTextLabel({
            Text = props.statName, -- :) <-- this is a smile, i hope it made you smile!
            BackgroundTransparency = 1,
            Font = props.font,
            TextSize = props.fontSize,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextStrokeTransparency = 0,
            Size = UDim2.new(props.Size.X.Scale,statWidth.X,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 1,
            TextYAlignment = Enum.TextYAlignment.Center,
        }),
        valueLabel = ShadowedTextLabel({
            BackgroundTransparency = 1,
            Text = props.value,
            Font = props.font,
            TextSize = props.fontSize + ((self.state.scale-1)*25),
            TextColor3 = Color3.fromRGB(255,255,255),
            TextStrokeTransparency = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Size = UDim2.new(props.Size.X.Scale,valueWidth.X,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 2,
        }),
    }

    if props.iconImage then
        children.iconFrame = Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(props.Size.X.Scale,props.Size.Y.Offset,props.Size.Y.Scale,props.Size.Y.Offset),
            LayoutOrder = 0,
        },{
            icon = Roact.createElement("ImageLabel", {
                Name = "iconLabel",
                BackgroundTransparency = 1,
                Image = props.iconImage,
                Rotation = self.state.iconRotation,
                AnchorPoint = Vector2.new(0.5,0.5),
                Size = UDim2.new(self.state.scale,0,self.state.scale,0),
                Position = UDim2.new(0.5,self.state.xOffset,0.5,self.state.yOffset),
            }),
        })
    end

    return Roact.createElement("Frame",{
        Name = "counterFrame",
        AnchorPoint = Vector2.new(0,0.5),
        Size = props.Size,
        Position = props.Position,
        BackgroundTransparency = 1,
    }, children)
end

return StatCounter