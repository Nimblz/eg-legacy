local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CAS = game:GetService("ContextActionService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Common = ReplicatedStorage:WaitForChild("common"):WaitForChild("util")
local Lib = ReplicatedStorage:WaitForChild("lib")

local HatUtil = require(Common:WaitForChild("HatUtil"))

local Roact = require(Lib:WaitForChild("Roact"))

local Customizer = {}

local Inventory = require(script.component.Inventory)
local ColorSelector = require(script.component.ColorSelector)

local ToggleHatSelector

local Props = {
	Hats = HatUtil.Hats,
	Colors = {
		BrickColor.new("White").Color,
		Color3.fromRGB(255, 140, 157), -- Pastel Red (not pink)
		Color3.fromRGB(255, 181, 97), -- orang
		Color3.fromRGB(255, 232, 101), -- yeller
		Color3.fromRGB(163, 245, 108), -- lime
		Color3.fromRGB(121, 216, 143), -- green
		Color3.fromRGB(159, 243, 233), -- cyan
		Color3.fromRGB(200, 197, 255), -- indego
		Color3.fromRGB(210, 172, 232), -- violet
		Color3.fromRGB(255, 171, 251), -- pank
	},
	Enabled = false
}

local InventoryApp = (function(props)
	return Roact.createElement("ScreenGui", {
		Name = "Customizer",
		ResetOnSpawn = false
	}, {
	Roact.createElement("Frame", {
		Size = UDim2.new(1,0,1,0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		}, {
		Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0,24),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		Inv = Inventory(props),
		ColorSelec = ColorSelector(props)
	}),
	Roact.createElement("TextButton", {
		Size = UDim2.new(1/2,0,1/15,0),
		AnchorPoint = Vector2.new(0.5,1),
		Position = UDim2.new(0.5,0,1-(1/30),0),
		Text = "Press [X] or Press here to open the debug menu.",
		Font = Enum.Font.Gotham,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1,1,1),
		TextStrokeColor3 = Color3.new(0,0,0),
		TextStrokeTransparency = 0.6,
		TextScaled = true,
		[Roact.Event.MouseButton1Click] = (function() ToggleHatSelector(nil,Enum.UserInputState.Begin) end)
	})
}) end)

function Customizer:init()
	-- local Handle = Roact.mount(InventoryApp(Props), PlayerGui)

	-- ToggleHatSelector = function(name,state)
	-- 	if state == Enum.UserInputState.Begin then
	-- 		Props.Enabled = not Props.Enabled

	-- 		Roact.reconcile(Handle, InventoryApp(Props))
	-- 	end
	-- end

	-- CAS:BindAction("togglehats",ToggleHatSelector,false,Enum.KeyCode.X, Enum.KeyCode.E, Enum.KeyCode.ButtonX)
end

return Customizer