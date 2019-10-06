local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local middleware = script:WaitForChild("middleware")

local Rodux = require(lib:WaitForChild("Rodux"))
local Signal = require(lib:WaitForChild("Signal"))

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Dictionary = require(common:WaitForChild("Dictionary"))
local Promise = require(lib:WaitForChild("Promise"))

local reducer = require(common:WaitForChild("commonReducer"))
local networkMiddleware = require(middleware:WaitForChild("networkMiddleware"))
local dataSaveMiddleware = require(middleware:WaitForChild("dataSaveMiddleware"))

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

    local function replicate(action,beforeState,afterState)
        -- Create a version of each action that's explicitly flagged as
        -- replicated so that clients can handle them explicitly.
        local replicatedAction = Dictionary.join(action, {
            replicated = true,
        })

        -- This is an action that everyone should see!
        if action.replicateBroadcast then
            return self.api:storeAction(self.api.AllPlayers, replicatedAction)
        end

        -- This is an action that we want a specific player to see.
        if action.replicateTo ~= nil then
            local player = action.replicateTo

            if player == nil then
                return
            end

            return self.api:storeAction(player, replicatedAction)
        end

        return
    end

    self.store = Rodux.Store.new(reducer,initialState, {
        Rodux.thunkMiddleware,
        networkMiddleware(replicate),
        dataSaveMiddleware,
    })
    self.storeCreated:fire()
    self.logger:log("Server store initialized.")
end

function StoreContainer:preInit()
    self.logger = self.core:getModule("Logger"):createLogger(self)
end

function StoreContainer:init()
    self.core:getModule("ServerApi"):getApi():andThen(function(api)
        self.api = api
        self:createStore()
    end)
end

function StoreContainer:postInit()
end

return StoreContainer