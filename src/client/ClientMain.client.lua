-- local Players = game:GetService("Players")
-- local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local common = ReplicatedStorage:WaitForChild("common")
-- local commonUtil = common:WaitForChild("util")
-- local lib = ReplicatedStorage:WaitForChild("lib")
-- local moduleBin = PlayerScripts:WaitForChild("module")

-- local Rodux = require(lib:WaitForChild("Rodux"))
-- local ClientApi = require(PlayerScripts:WaitForChild("ClientApi"))

-- local callOnAll = require(commonUtil:WaitForChild("callOnAll"))

-- local Client = {}

-- Client.modules = {
-- 	EgLegAnimator = require(moduleBin:WaitForChild("EgLegAnimator")),
-- 	Portals = require(moduleBin:WaitForChild("Portals")),
-- 	Cannons = require(moduleBin:WaitForChild("Cannons")),
-- 	CoinSpawner = require(moduleBin:WaitForChild("CoinSpawner")),
-- 	Sound = require(moduleBin:WaitForChild("Sound")),
-- 	Gui = require(moduleBin:WaitForChild("Gui")),
-- 	EquipmentRenderer = require(moduleBin:WaitForChild("EquipmentRenderer")),
-- 	RecsCoreContainer = require(moduleBin:WaitForChild("RecsCoreContainer")),
-- 	AreaLighting = require(moduleBin:WaitForChild("AreaLighting")),
-- 	--CharacterMovement = require(moduleBin:WaitForChild("CharacterMovement")),
-- }

-- Client.toLoad = {
-- 	Client.modules.Sound,
-- 	Client.modules.RecsCoreContainer,
-- 	Client.modules.EgLegAnimator,
-- 	Client.modules.Portals,
-- 	Client.modules.Cannons,
-- 	Client.modules.Gui,
-- 	Client.modules.EquipmentRenderer,
-- 	Client.modules.CharacterMovement,
-- 	Client.modules.CoinSpawner,
-- 	Client.modules.AreaLighting,
-- }
-- function Client:getModule(name)
-- 	assert(self.modules[name],"No such module: "..name)
-- 	return self.modules[name]
-- end

-- function Client:load()
-- 	-- init all modules
-- 	callOnAll(Client.toLoad,"init")

-- 	-- player is ready, start all modules
-- 	callOnAll(Client.toLoad,"start",self)
-- end

-- Client.api = ClientApi.new({
-- 	initialPlayerState = function(gameState)
-- 		Client.store = Rodux.Store.new(require(PlayerScripts:WaitForChild("clientReducer")), gameState, {
-- 			Rodux.thunkMiddleware,
-- 			--Rodux.loggerMiddleware,
-- 		})

-- 		Client:load()
-- 	end,

-- 	storeAction = function(action)
-- 		if Client.store ~= nil then
-- 			Client.store:dispatch(action)
-- 		end
-- 	end,

-- 	coinRespawn = function(coinSpawn)
-- 		Client:getModule("CoinSpawner"):spawnCoin(coinSpawn)
-- 	end,

-- 	equippedBroadcast = function(player, assetid, payload)

-- 	end,
-- })

-- Client.api:connect()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local src = script.Parent

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))

local module = common:WaitForChild("module")

local sidedmodule = src:WaitForChild("module")

local gameCore = PizzaAlpaca.GameCore.new()
gameCore._debugprints = true

gameCore:registerChildrenAsModules(module)
gameCore:registerChildrenAsModules(sidedmodule)

gameCore:load()