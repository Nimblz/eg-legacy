local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local Selectors = require(common:WaitForChild("Selectors"))

local component = script.Parent

local StatsFrame = require(component:WaitForChild("StatsFrame"))
local ChangelogView = require(component:WaitForChild("ChangelogView"))
local SettingsView = require(component:WaitForChild("SettingsView"))
local InventoryView = require(component:WaitForChild("InventoryView"))
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
        inventory = Roact.createElement(InventoryView, {clientApi = self.props.clientApi}),
        shop = Roact.createElement(ShopView, self.props),
    }

    return Roact.createElement("ScreenGui", {
        Name = "gameGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, {
        statframe = Roact.createElement(StatsFrame),

        currentView = views[self.props.view],

        sideMenu = Roact.createElement(SideMenu, self.props),

        versionLabel = Roact.createElement(VersionLabel, self.props),
    })
end

local function mapStateToProps(state,props)
    return {
        view = state.uiState.view,
    }
end

return RoactRodux.connect(mapStateToProps,nil)(App)