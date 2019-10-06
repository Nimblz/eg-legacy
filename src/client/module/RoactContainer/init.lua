local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local localPlayer = Players.LocalPlayer
local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Promise = require(lib:WaitForChild("Promise"))
local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))

local component = script:WaitForChild("component")

local App = require(component:WaitForChild("App"))

local RoactContainer = PizzaAlpaca.GameModule:extend("RoactContainer")

local function makeElementTree(store,api)

    local currentCam = game:GetService("Workspace").CurrentCamera

    local viewportSize = currentCam.ViewportSize

    return Roact.createElement(RoactRodux.StoreProvider, {
        store = store,
    }, {
        app = Roact.createElement(App, {
            viewportSize = viewportSize,
            clientApi = api,
        }),
    })
end

function RoactContainer:init()
    local StoreContainer = self.core:getModule("StoreContainer")
    local ClientApi = self.core:getModule("ClientApi")

    Promise.all({
        StoreContainer:getStore(),
        ClientApi:getApi(),
    }):andThen(function(resolved)
        local store, api = unpack(resolved)
        local currentCam = game:GetService("Workspace").CurrentCamera

        local handle = Roact.mount(makeElementTree(store,api), localPlayer:WaitForChild("PlayerGui"))

        currentCam:GetPropertyChangedSignal("ViewportSize"):connect(function()
            Roact.update(handle, makeElementTree(store,api))
        end)
    end)
end

return RoactContainer