local Players = game:GetService("Players")

local server = script.Parent.Parent

local Thunks = require(server:WaitForChild("thunks"))

local PlayerHandler = {}

function PlayerHandler:init()

end

function PlayerHandler:start(server)
    local store = server.store
    local api = server.api
    Players.PlayerAdded:Connect(function(player)
        store:dispatch(Thunks.PLAYER_JOINED(player,api))
    end)

    Players.PlayerRemoving:Connect(function(player)
        store:dispatch(Thunks.PLAYER_LEAVING(player))
    end)
end

return PlayerHandler