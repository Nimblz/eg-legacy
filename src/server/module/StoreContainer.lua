local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local middleware = ServerScriptService:WaitForChild("middleware")

local Rodux = require(lib:WaitForChild("Rodux"))
local Signal = require(lib:WaitForChild("Signal"))

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Dictionary = require(common.Dictionary)

local reducer = require(common:WaitForChild("commonReducer"))
local networkMiddleware = require(middleware:WaitForChild("networkMiddleware"))
local dataSaveMiddleware = require(middleware:WaitForChild("dataSaveMiddleware"))

local StoreContainer = PizzaAlpaca.GameModule:extend("StoreContainer")



function StoreContainer:create()
    self.storeInitialized = Signal.new()
end

function StoreContainer:getStore()
    return self.store
end

function StoreContainer:initializeStore(initialState)

    -- From Lucien Greathouses RDC 2018 project
    -- https://github.com/LPGhatguy/rdc-project/blob/master/src/server/main.lua
    local function replicate(action,beforeState,afterState)
        -- Create a version of each action that's explicitly flagged as
        -- replicated so that clients can handle them explicitly.
        local replicatedAction = Dictionary.join(action, {
            replicated = true,
        })

        -- This is an action that everyone should see!
        if action.replicateBroadcast then
            print(self.api.AllPlayers)
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

    self.logger:log("Local store initialized.")
    self.store = Rodux.Store.new(reducer,initialState, {
        Rodux.thunkMiddleware,
        networkMiddleware(replicate),
        dataSaveMiddleware,
    })
    self.storeInitialized:fire(self.store)
end

function StoreContainer:preInit()
    self.logger = self.core:getModule("Logger"):createLogger(self)
end

function StoreContainer:init()
    self.api = self.core:getModule("ServerApi"):getApi()
    self:initializeStore()
end

function StoreContainer:postInit()
end

return StoreContainer