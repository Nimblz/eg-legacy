-- PLAYER_JOINED thunk
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))

local PLAYER_ADD = Actions.PLAYER_ADD

return function(player,api)
    return function(store)
        local playerSaveTable = { -- test save
            portals = {
                AutumnPortal = true,
                ForestPortal = true,
                MountainPortal = true,
                OceanPortal = true,
                SkyPortal = true,
                TundraPortal = true,
                UndergroundPortal = true,
            },
            stats = {
                coins = 15000,
            }
        }
        if game.PlaceId ~= 0 then
            local PlayerDataStore = require(lib:WaitForChild("PlayerDataStore"))
            local saveData = PlayerDataStore:GetSaveData(player)
            playerSaveTable = saveData:Get("playerSaveTable") or {}
        end

        store:dispatch(PLAYER_ADD(player,playerSaveTable))
        api:initialPlayerState(player,store:getState())
    end
end