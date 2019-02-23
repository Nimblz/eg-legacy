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
	LegacyCustomizer = require(moduleBin:WaitForChild("LegacyCustomizer")),
	Gui = require(moduleBin:WaitForChild("Gui")),
}

function Client:getModule(name)
	assert(self.modules[name],"No such module: "..name)
	return self.modules[name]
end

function Client:load()
	-- init all modules
	callOnAll(Client.modules,"init")

	Client.api = ClientApi.connect({
		initialPlayerState = function(state)
			Client.store = Rodux.Store.new(require(PlayerScripts:WaitForChild("clientReducer")), state, {
				Rodux.thunkMiddleware,
			})

			-- player is ready, start all modules
			callOnAll(Client.modules,"start",Client)
		end,
		storeAction = function(action)
			if Client.store ~= nil then
				Client.store:dispatch(action)
			end
		end,
		coinRespawn = function(coinSpawn)
			self:getModule("Coins"):spawnCoin(coinSpawn)
		end
	})

end


Client:load()