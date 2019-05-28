local ReplicatedStorage = game:GetService("ReplicatedStorage")

local client = script.Parent.Parent
local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local RECS = require(lib:WaitForChild("RECS"))
local Components = require(client:WaitForChild("Components"))
local Systems = require(client:WaitForChild("Systems"))
local Steppers = require(client:WaitForChild("Steppers"))

local createCollectionServicePlugin = require(client:WaitForChild("createCollectionServicePlugin"))
local createInjectorPlugin = require(client:WaitForChild("createInjectorPlugin"))

local RecsCoreContainer = {}

function RecsCoreContainer:init()
end

function RecsCoreContainer:start(client)
    self.recsCore = RECS.Core.new({
        createCollectionServicePlugin(),
        createInjectorPlugin("getClientModule", function(_, name) return client:getModule(name) end),
        createInjectorPlugin("api", client.api)
    })
    for _,component in pairs(Components) do
        self.recsCore:registerComponent(component)
    end
    self.recsCore:registerSystems(Systems)
    self.recsCore:registerSteppers(Steppers)
    self.recsCore:start()
end

return RecsCoreContainer