-- PLAYER_JOINED thunk
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local PlayerDataStore = require(lib:WaitForChild("PlayerDataStore"))

local Actions = require(common:WaitForChild("Actions"))

local PLAYER_ADD = Actions.PLAYER_ADD

return function(player,api)
    return function(store)
        local saveData = PlayerDataStore:GetSaveData(player)

        local playerSaveTable = saveData:Get("playerSaveTable") or {}

        store:dispatch(PLAYER_ADD(player,playerSaveTable))

        api:initialPlayerState(player,playerSaveTable)
    end
end