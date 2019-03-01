-- PLAYER_LEAVING thunk
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local PlayerDataStore = require(lib:WaitForChild("PlayerDataStore"))

local Actions = require(common:WaitForChild("Actions"))

local PLAYER_REMOVE = Actions.PLAYER_REMOVE

return function(player)
    return function(store)
        local playerSaveTable = store:getState().players[player]

        if playerSaveTable then
            local saveData = PlayerDataStore:GetSaveData(player)

            saveData:Set("playerSaveTable", playerSaveTable)
        end
        store:dispatch(PLAYER_REMOVE(player))
    end
end