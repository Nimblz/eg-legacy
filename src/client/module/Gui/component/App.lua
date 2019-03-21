local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

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
    return Roact.createElement("ScreenGui", {
        Name = "gameGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, {
        statframe = StatsFrame(self.props.playerState.stats),

        changelogView = Roact.createElement(ChangelogView, self.props),
        settingsView = Roact.createElement(SettingsView, self.props),
        inventoryView = Roact.createElement(InventoryView, self.props),
        shopView = Roact.createElement(ShopView, self.props),

        sideMenu = Roact.createElement(SideMenu, self.props),

        versionLabel = Roact.createElement(VersionLabel, self.props),
    })
end

local function mapStateToProps(state,props)
    return {
        playerState = state.playerState,
        settings = state.settings or {}, -- not implemented yet

        view = state.uiState.view,
        catagory = state.uiState.catagory,
    }
end

return RoactRodux.connect(mapStateToProps,nil)(App)