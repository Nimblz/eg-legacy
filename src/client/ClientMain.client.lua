local Players = game:GetService("Players")
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local commonUtil = common:WaitForChild("util")
local lib = ReplicatedStorage:WaitForChild("lib")
local moduleBin = PlayerScripts:WaitForChild("module")

local Rodux = require(lib:WaitForChild("Rodux"))
local ClientApi = require(PlayerScripts:WaitForChild("ClientApi"))

local callOnAll = require(commonUtil:WaitForChild("callOnAll"))

local Client = {}

Client.modules = {
	EgLegAnimator = require(moduleBin:WaitForChild("EgLegAnimator")),
	Portals = require(moduleBin:WaitForChild("Portals")),
	Cannons = require(moduleBin:WaitForChild("Cannons")),
	Coins = require(moduleBin:WaitForChild("Coins")),
	Sound = require(moduleBin:WaitForChild("Sound")),
	Gui = require(moduleBin:WaitForChild("Gui")),
	EquipmentRenderer = require(moduleBin:WaitForChild("EquipmentRenderer")),
	CharacterMovement = require(moduleBin:WaitForChild("CharacterMovement")),
}

function Client:getModule(name)
	assert(self.modules[name],"No such module: "..name)
	return self.modules[name]
end

function Client:load()
	-- init all modules
	callOnAll(Client.modules,"init")

	-- player is ready, start all modules
	callOnAll(Client.modules,"start",self)
end

Client.api = ClientApi.new({
	initialPlayerState = function(gameState)
		Client.store = Rodux.Store.new(require(PlayerScripts:WaitForChild("clientReducer")), gameState, {
			Rodux.thunkMiddleware,
			--Rodux.loggerMiddleware,
		})

		Client:load()
	end,

	storeAction = function(action)
		if Client.store ~= nil then
			Client.store:dispatch(action)
		end
	end,

	coinRespawn = function(coinSpawn)
		Client:getModule("Coins"):spawnCoin(coinSpawn)
	end,

	equippedBroadcast = function(player, assetid, payload)

	end,
})

Client.api:connect()