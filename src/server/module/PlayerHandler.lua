local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local Actions = require(common:WaitForChild("Actions"))

local PlayerHandler = {}

function PlayerHandler:init()

end

function PlayerHandler:start(server)
    local store = server.store
    local api = server.api
    Players.PlayerAdded:Connect(function(player)
        store:dispatch(Actions.PLAYER_JOINED(player,api))
    end)

    Players.PlayerRemoving:Connect(function(player)
        store:dispatch(Actions.PLAYER_LEAVING(player))
    end)
end

return PlayerHandler