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
                DesertPortal = true,
                AbyssPortal = true,
            },
            inventory = {
                ["invaliditem"] = true,
            },
            stats = {
                coins = 250000,
            }
        }
        local defaultSave = {
            portals = {
            },
            inventory = {
                -- default items should be given each time a player joins
                -- if they're just defined here then returning players
                -- will not retroactively get them.
            },
            stats = {
                coins = 2500,
            }
        }
        if game.PlaceId ~= 0 then
            local PlayerDataStore = require(lib:WaitForChild("PlayerDataStore"))
            local saveData = PlayerDataStore:GetSaveData(player)
            playerSaveTable = saveData:Get("playerSaveTable") or defaultSave
        end

        store:dispatch(PLAYER_ADD(player,playerSaveTable))
        api:initialPlayerState(player,store:getState())
    end
end