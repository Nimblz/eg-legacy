-- PLAYER_JOINED thunk
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))

local PLAYER_ADD = Actions.PLAYER_ADD

return function(player)
    return function(store)
        local playerSaveTable
        local defaultSave = {
            portals = {
                AbyssPortal = false
            },
            inventory = {
                -- default items should be given each time a player joins
                -- if they're just defined here then returning players
                -- will not retroactively get them.
            },
            stats = {
                coins = 0,
            }
        }
        if game.PlaceId ~= 0 then
            local DataStore2 = require(lib:WaitForChild("DataStore2"))

            -- load from datastore2
            local saveDataStore = DataStore2("saveData",player)
            local dataStore2SaveTable = saveDataStore:Get(nil)

            if not dataStore2SaveTable then
                print("No loaded, goin with default!")
                playerSaveTable = defaultSave
            else
                playerSaveTable = dataStore2SaveTable
            end
        end

        store:dispatch(PLAYER_ADD(player, playerSaveTable))
        print(("data loaded."))
    end
end