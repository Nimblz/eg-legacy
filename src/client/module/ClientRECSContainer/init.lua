-- TODO: Genericize this module and replace with a common RECSContainer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local recsPlugins = common:WaitForChild("recsplugins")

local RECS = require(lib:WaitForChild("RECS"))
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Signal = require(lib:WaitForChild("Signal"))
local Promise = require(lib:WaitForChild("Promise"))

local RecsComponents = require(common:WaitForChild("RecsComponents"))
local Systems = require(script.Systems)
local Steppers = require(script.Steppers)

local createInjectorPlugin = require(recsPlugins:WaitForChild("createInjectorPlugin"))
local createComponentPropsOverridePlugin = require(recsPlugins:WaitForChild("createComponentPropsOverridePlugin"))

local ClientRECSContainer = PizzaAlpaca.GameModule:extend("ClientRECSContainer")

function ClientRECSContainer:create()
    self.recsCoreCreated = Signal.new()
end

function ClientRECSContainer:onStoreAndApi(store,api)
    self.recsCore = RECS.Core.new({
        RECS.BuiltInPlugins.CollectionService(),
        RECS.BuiltInPlugins.ComponentChangedEvent,
        createComponentPropsOverridePlugin(),
        createInjectorPlugin("getClientModule", function(_, name)
            return self.core:getModule(name)
        end),
        createInjectorPlugin("pzCore", self.core),
        createInjectorPlugin("store", store),
        createInjectorPlugin("api", api),
    })

    -- register all components
    for _, component in pairs(RecsComponents) do
        self.recsCore:registerComponent(component)
    end

    self.recsCore:registerSystems(Systems)
    self.recsCore:registerSteppers(Steppers)
end

function ClientRECSContainer:getCore()
    return Promise.async(function(resolve, reject)
        if not self.recsCore then self.recsCoreCreated:wait() end
        resolve(self.recsCore)
    end)
end

function ClientRECSContainer:preInit()
end

function ClientRECSContainer:init()
    local storeContainer = self.core:getModule("StoreContainer")
    local clientApi = self.core:getModule("ClientApi")
    Promise.all({
        storeContainer:getStore(),
        clientApi:getApi(),
    }):andThen(function(resolved)
        local store, api = unpack(resolved)
        self:onStoreAndApi(store,api)

        self.recsCore:start()
        self.recsCoreCreated:fire(self.recsCore)
    end)
end

function ClientRECSContainer:postInit()
end


return ClientRECSContainer