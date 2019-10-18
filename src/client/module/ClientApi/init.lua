-- wrapper for lpghatguy's common api implementation
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))

local Signal = require(lib:WaitForChild("Signal"))
local Promise = require(lib:WaitForChild("Promise"))
local ClientApi = require(script:WaitForChild("ClientApi"))

local ClientApiWrapper = PizzaAlpaca.GameModule:extend("ClientApi")

function ClientApiWrapper:getApi()
    return Promise.async(function(resolve, reject)
        if not self.api then self.apiCreated:wait() end
        resolve(self.api)
    end)
end

function ClientApiWrapper:create()
	self.apiCreated = Signal.new()
end

function ClientApiWrapper:preInit()
end

function ClientApiWrapper:init()
    local storeContainer = self.core:getModule("StoreContainer")
    local coinSpawner = self.core:getModule("CoinSpawner")
    local candySpawner = self.core:getModule("CandySpawner")
    self.api = ClientApi.new({
        initialPlayerState = function(gameState)
            storeContainer:createStore(gameState)
        end,

        storeAction = function(action)
            storeContainer:getStore():andThen(function(store)
                store:dispatch(action)
            end)
        end,

        coinRespawn = function(coinSpawn)
            coinSpawner:spawnCoin(coinSpawn)
        end,

        candyRespawn = function(spawner)
            candySpawner:spawn(spawner)
        end,

        equippedBroadcast = function(player, assetid, payload)
            -- TODO: Equipment use handling
        end,
    })

    self.apiCreated:fire(self.api)
end

function ClientApiWrapper:postInit()
    self.api:connect()
    self.api:ready()
end


return ClientApiWrapper