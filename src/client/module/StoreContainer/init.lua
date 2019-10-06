-- contains the games store and handles action replication

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local src = script.Parent.Parent
local lib = ReplicatedStorage:WaitForChild("lib")

local Rodux = require(lib:WaitForChild("Rodux"))
local Signal = require(lib:WaitForChild("Signal"))
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Promise = require(lib:WaitForChild("Promise"))

local reducer = require(src:WaitForChild("clientReducer"))

local StoreContainer = PizzaAlpaca.GameModule:extend("StoreContainer")

function StoreContainer:create()
    self.storeCreated = Signal.new()
end

function StoreContainer:getStore()
    return Promise.async(function(resolve, reject)
        if not self.store then self.storeCreated:wait() end
        resolve(self.store)
    end)
end

function StoreContainer:createStore(initialState)
    local store = Rodux.Store.new(reducer,initialState, {
		Rodux.thunkMiddleware,
		--Rodux.loggerMiddleware,
    })

    self.store = store

    self.storeCreated:fire()
    self.logger:log("Client store initialized.")
end

function StoreContainer:preInit()
    self.logger = self.core:getModule("Logger"):createLogger(self)
end

function StoreContainer:init()
end

function StoreContainer:postInit()
end

return StoreContainer