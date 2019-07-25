-- wrapper for lpghatguy's common api implementation
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Actions = require(common:WaitForChild("Actions"))
local Thunks = require(common:WaitForChild("Thunks"))

local ServerApi = require(script:WaitForChild("ServerApi"))

local ServerApiWrapper = PizzaAlpaca.GameModule:extend("ServerApi")

function ServerApiWrapper:getApi()
    return self.api
end

function ServerApiWrapper:preInit()
	self.api = ServerApi.create({
		requestCoinCollect = function(player,coinSpawn)
			self:getModule("Coins"):requestCoinCollect(player,coinSpawn)
		end,

		portalActivate = function(player,portalName)
			self.store:dispatch(Actions.PORTAL_ACTIVATE(player,portalName))
			self:getModule("PortalsListener"):portalActivate(player,portalName)
		end,

		buyAsset = function(player,assetId)
			print("someone tried to buy")
			self.store:dispatch(Thunks.ASSET_TRYBUY(player, assetId))
		end,

		buyDevproduct = function(player,devproductId)
			self:getModule("Cashier"):promptPurchase(player,devproductId)
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
end

function ServerApiWrapper:init()
    local storeContainer = self.core:getModule("StoreContainer")
	self.store = storeContainer:getStore()
	self.api:connect()
end

function ServerApiWrapper:postInit()
end


return ServerApiWrapper