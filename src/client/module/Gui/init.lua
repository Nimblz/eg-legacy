local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local localPlayer = Players.LocalPlayer
local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))

local component = script:WaitForChild("component")

local App = require(component:WaitForChild("App"))

local Gui = {}

local function makeElementTree(client)
    local store = client.store
    local currentCam = game:GetService("Workspace").CurrentCamera

    local viewportSize = currentCam.ViewportSize

    return Roact.createElement(RoactRodux.StoreProvider, {
        store = store,
    }, {
        app = Roact.createElement(App, {
            viewportSize = viewportSize,
            clientApi = client.api,
        }),
    })
end

local function ShowView()
    return Enum.ContextActionResult.Pass
end

function Gui:init()

end

function Gui:start(client)

    local currentCam = game:GetService("Workspace").CurrentCamera

    local handle = Roact.mount(makeElementTree(client), localPlayer:WaitForChild("PlayerGui"))

    currentCam:GetPropertyChangedSignal("ViewportSize"):connect(function()
        Roact.update(handle, makeElementTree(client))
    end)
end

return Gui