local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local Selectors = require(common:WaitForChild("Selectors"))
local Dictionary = require(common:WaitForChild("Dictionary"))

local component = script.Parent

local StatsFrame = require(component:WaitForChild("StatsFrame"))
local ChangelogView = require(component:WaitForChild("ChangelogView"))
local SettingsView = require(component:WaitForChild("SettingsView"))
local InventoryView = require(component:WaitForChild("InventoryView"))
local DevProductShopView = require(component:WaitForChild("DevProductShopView"))
local ShadowedTextLabel = require(component:WaitForChild("ShadowedTextLabel"))
local ShopView = require(component:WaitForChild("ShopView"))
local SideMenu = require(component:WaitForChild("SideMenu"))
local VersionLabel = require(component:WaitForChild("VersionLabel"))

local App = Roact.Component:extend("App")

function App:init(props)

end

function App:didMount()

end

function App:render()

    local views = {
        changelog = Roact.createElement(ChangelogView, self.props),
        settings = Roact.createElement(SettingsView, self.props),
        inventory = Roact.createElement(InventoryView, {clientApi = self.props.clientApi, viewportSize = self.props.viewportSize}),
        devproducts = Roact.createElement(DevProductShopView, {clientApi = self.props.clientApi, viewportSize = self.props.viewportSize, view = self.props.view}),
        shop = Roact.createElement(ShopView, {clientApi = self.props.clientApi, viewportSize = self.props.viewportSize}),
    }

    return Roact.createElement("ScreenGui", {
        Name = "gameGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, Dictionary.join({
            statframe = Roact.createElement(StatsFrame, self.props),

            sideMenu = Roact.createElement(SideMenu, self.props),

            versionLabel = Roact.createElement(VersionLabel, self.props),

            likesLabel = Roact.createElement(ShadowedTextLabel, {
                AnchorPoint = Vector2.new(1,1),
                Position = UDim2.new(1,-16,1,-16),
                Size = UDim2.new(1/2,0,1/10,0),
                BackgroundTransparency = 1,
                TextStrokeTransparency = 0,
                Text = "Enjoying the game? Leave a like 👍 ! It helps a lot! Something special will happen once we reach 50k 👍! ",
                Font = Enum.Font.GothamBlack,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextYAlignment = Enum.TextYAlignment.Bottom,
            })
        }, views)
    )
end

local function mapStateToProps(state,props)
    return {
        view = Selectors.getUIView(state),
    }
end

return RoactRodux.connect(mapStateToProps,nil)(App)