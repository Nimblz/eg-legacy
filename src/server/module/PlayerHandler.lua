local Players = game:GetService("Players")

local source = script.Parent.Parent

local Thunks = require(source:WaitForChild("Thunks"))

local PlayerHandler = {}

local function playerAdded(player,store,api)
    store:dispatch(Thunks.PLAYER_JOINED(player,api))
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