local Players = game:GetService("Players")
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local commonUtil = common:WaitForChild("util")

local moduleBin = PlayerScripts:WaitForChild("module")

local FuncUtil = require(commonUtil:WaitForChild("FuncUtil"))

local Client = {}

Client.modules = {
	EgLegAnimator = require(moduleBin:WaitForChild("EgLegAnimator")),
	Portals = require(moduleBin:WaitForChild("Portals")),
	Cannons = require(moduleBin:WaitForChild("Cannons")),
}

function Client:getModule(name)
	assert(self.modules[name],"No such module: "..name)
	return self.modules[name]
end

function Client:load()
	-- init all modules
	FuncUtil.callOnAll(Client.modules,"init")
	-- start all modules
	FuncUtil.callOnAll(Client.modules,"start",Client)
end


Client:load()