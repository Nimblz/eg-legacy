local ServerScriptService = game:GetService("ServerScriptService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local commonUtil = common:WaitForChild("util")
local lib = ReplicatedStorage:WaitForChild("lib")
local moduleBin = ServerScriptService:WaitForChild("module")

local Rodux = require(lib:WaitForChild("Rodux"))
local FuncUtil = require(commonUtil:WaitForChild("FuncUtil"))

local serverReducer = require(ServerScriptService:WaitForChild("serverReducer"))

local Server = {}

Server.modules = {
	PlayerHandler = require(moduleBin:WaitForChild("PlayerHandler")),
	Cashier = require(moduleBin:WaitForChild("Cashier")),
	TimeBadges = require(moduleBin:WaitForChild("TimeBadges")),
	CharacterHandler = require(moduleBin:WaitForChild("CharacterHandler")),
	Coins = require(moduleBin:WaitForChild("Coins")),
	LegacyCustomization = require(moduleBin:WaitForChild("LegacyCustomization")),
}

Server.store = Rodux.Store.new(serverReducer, nil, {
	Rodux.thunkMiddleware,
	--Rodux.loggerMiddleware,
})

function Server:getModule(name)
	assert(self.modules[name],"No such module: "..name)
	return self.modules[name]
end

function Server:load()
	-- init all modules
	FuncUtil.callOnAll(Server.modules,"init")
	-- start all modules
	FuncUtil.callOnAll(Server.modules,"start",Server)
end

-- Load modules
Server:load()