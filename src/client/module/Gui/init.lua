local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local component = script:WaitForChild("component")

local App = require(component:WaitForChild("App"))

local Gui = {}

function Gui:init()

end

function Gui:start(client)
    local store = client.store

    Gui.appRoot = Roact.createElement(RoactRodux.StoreProvider, {
        store = store,
    }, {
        app = Roact.createElement(App),
    })

    Roact.mount(Gui.appRoot, localPlayer:WaitForChild("PlayerGui"))
end

return Gui