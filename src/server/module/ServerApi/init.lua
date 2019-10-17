-- wrapper for lpghatguy's common api implementation
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Promise = require(lib:WaitForChild("Promise"))
local Signal = require(lib:WaitForChild("Signal"))

local Actions = require(common:WaitForChild("Actions"))
local Thunks = require(common:WaitForChild("Thunks"))

local ServerApi = require(script:WaitForChild("ServerApi"))

local ServerApiWrapper = PizzaAlpaca.GameModule:extend("ServerApi")

function ServerApiWrapper:getApi()
    return Promise.async(function(resolve, reject)
        if not self.api then self.apiCreated:wait() end
        resolve(self.api)
    end)
end

function ServerApiWrapper:create()
	self.apiCreated = Signal.new()
end

function ServerApiWrapper:preInit()
	self.api = ServerApi.create({
		requestCoinCollect = function(player,coinSpawn)
			self.core:getModule("Coins"):requestCoinCollect(player,coinSpawn)
		end,

		requestCandyCollect = function(player,coinSpawn)
			self.core:getModule("Candy"):requestCollect(player,coinSpawn)
		end,

		portalActivate = function(player,portalName)
			self.store:dispatch(Actions.PORTAL_ACTIVATE(player,portalName))
			self.core:getModule("PortalsListener"):portalActivate(player,portalName)
		end,

		buyAsset = function(player,assetId)
			self.store:dispatch(Thunks.ASSET_TRYBUY(player, assetId))
		end,

		buyDevproduct = function(player,devproductId)
			self.core:getModule("Cashier"):promptPurchase(player,devproductId)
		end,

		equipAsset = function(player,assetId)
			self.store:dispatch(Thunks.ASSET_TRYEQUIP(player, assetId))
		end,

		unequipAsset = function(player,assetId)
			self.store:dispatch(Actions.ASSET_UNEQUIP(player, assetId))
		end,

		equippedAction = function(player, assetid, payload)
			print(("%s used %s"):format(player.Name,assetid))
		end,
	})

	self.apiCreated:fire(self.api)
end

function ServerApiWrapper:init()
    local storeContainer = self.core:getModule("StoreContainer")
	storeContainer:getStore():andThen(function(store)
		self.store = store
		self.api:connect()
	end)
end

function ServerApiWrapper:postInit()
end


return ServerApiWrapper