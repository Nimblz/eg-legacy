local ServerScriptService = game:GetService("ServerScriptService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local commonUtil = common:WaitForChild("util")
local lib = ReplicatedStorage:WaitForChild("lib")
local moduleBin = ServerScriptService:WaitForChild("module")
local middleware = ServerScriptService:WaitForChild("middleware")

local Rodux = require(lib:WaitForChild("Rodux"))
local ServerApi = require(ServerScriptService:WaitForChild("ServerApi"))
local Dictionary = require(common.Dictionary)
local Actions = require(common:WaitForChild("Actions"))
local Thunks = require(common:WaitForChild("Thunks"))

local callOnAll = require(commonUtil:WaitForChild("callOnAll"))
local reducer = require(common:WaitForChild("commonReducer"))
local networkMiddleware = require(middleware:WaitForChild("networkMiddleware"))
local dataSaveMiddleware = require(middleware:WaitForChild("dataSaveMiddleware"))

local Server = {}

Server.modules = {
	PlayerHandler = require(moduleBin:WaitForChild("PlayerHandler")),
	Cashier = require(moduleBin:WaitForChild("Cashier")),
	CharacterHandler = require(moduleBin:WaitForChild("CharacterHandler")),
	Coins = require(moduleBin:WaitForChild("Coins")),
	AchievementAwarder = require(moduleBin:WaitForChild("AchievementAwarder")),
	PortalsListener = require(moduleBin:WaitForChild("PortalsListener")),
	DayNight = require(moduleBin:WaitForChild("DayNight")),
	PlayerEquipment = require(moduleBin:WaitForChild("PlayerEquipment")),
}

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
		return Server.api:storeAction(ServerApi.AllPlayers, replicatedAction)
	end

	-- This is an action that we want a specific player to see.
	if action.replicateTo ~= nil then
		local player = action.replicateTo

		if player == nil then
			return
		end

		return Server.api:storeAction(player, replicatedAction)
	end

	return
end

function Server:getModule(name)
	assert(self.modules[name],"No such module: "..name)
	return self.modules[name]
end

function Server:load()

	self.store = Rodux.Store.new(reducer, nil, {
		Rodux.thunkMiddleware,
		networkMiddleware(replicate),
		dataSaveMiddleware,
		--Rodux.loggerMiddleware,
	})

	self.api = ServerApi.create({
		requestCoinCollect = function(player,coinSpawn)
			self:getModule("Coins"):requestCoinCollect(player,coinSpawn)
		end,

		portalActivate = function(player,portalName)
			self.store:dispatch(Actions.PORTAL_ACTIVATE(player,portalName))
			self:getModule("PortalsListener"):portalActivate(player,portalName)
		end,

		buyAsset = function(player,assetId)
			self.store:dispatch(Thunks.ASSET_TRYBUY(player, assetId))
		end,

		buyDevproduct = function(player,devproductId)
			self:getModule("Cashier"):PromptPurchase(player,devproductId)
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
	self.api:connect()

	-- init all modules
	callOnAll(self.modules,"init")

	-- start all modules
	callOnAll(self.modules,"start",Server)
end

-- Load modules
Server:load()
_G.server = Server