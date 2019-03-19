-- PLAYER_JOINED thunk
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))

local PLAYER_ADD = Actions.PLAYER_ADD

return function(player,api)
    return function(store)
        local playerSaveTable = { -- test save
            stats = {
                coins = 250,
            }
        }
        if game.PlaceId ~= 0 then
            local PlayerDataStore = require(lib:WaitForChild("PlayerDataStore"))
            local saveData = PlayerDataStore:GetSaveData(player)
            playerSaveTable = saveData:Get("playerSaveTable") or {}
        end

        store:dispatch(PLAYER_ADD(player,playerSaveTable))

        api:initialPlayerState(player,playerSaveTable)
    end
end