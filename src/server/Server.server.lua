local ServerScriptService = game:GetService("ServerScriptService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local commonUtil = common:WaitForChild("util")

local moduleBin = ServerScriptService:WaitForChild("module")

local FuncUtil = require(commonUtil:WaitForChild("FuncUtil"))

local Server = {}

Server.modules = {
	TipJarProducts = require(moduleBin:WaitForChild("TipJarProducts")),
	TimeBadges = require(moduleBin:WaitForChild("TimeBadges")),
	CustomizerRemotes = require(moduleBin:WaitForChild("CustomizerRemotes")),
}

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


Server:load()