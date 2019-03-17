local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local source = script.Parent.Parent
local lib = ReplicatedStorage:WaitForChild("lib")

local Thunks = require(source:WaitForChild("Thunks"))

local Signal = require(lib:WaitForChild("Signal"))

local PlayerHandler = {}
PlayerHandler.playerLoaded = Signal.new()

local function playerAdded(player,store,api)
    store:dispatch(Thunks.PLAYER_JOINED(player,api))
    PlayerHandler.playerLoaded:fire(player)
end

local function playerLeaving(player,store)
	store:dispatch(Thunks.PLAYER_LEAVING(player))
end

function PlayerHandler:start(server)
    local store = server.store
    local api = server.api

    Players.PlayerAdded:Connect(function(player)
        playerAdded(player,store,api)
    end)

    Players.PlayerRemoving:Connect(function(player)
		playerLeaving(player,store)
    end)

	for _,player in pairs(Players:GetPlayers()) do
		playerAdded(player,store,api)
	end
end

return PlayerHandler