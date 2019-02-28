-- PLAYER_JOINED thunk

local PLAYER_ADD = require(script.Parent:WaitForChild("PLAYER_ADD"))

return function(player,api)
    return function(store)
        local saveData = {
            portals = {
                UndergroundPortal = false,
                AutumnPortal = false,
                MountainPortal = false,
                ForestPortal = true,
                TundraPortal = false,
                OceanPortal = false,
                SkyPortal = false
            },

            stats = {
                playTime = 420, -- in mins
                playedYesterday = true,
                consecutiveDays = 5,
                metersWalked = 9001,
                coins = 1337,
            },

            achievements = {
                joinGame = true,
                coins1000 = true,
                touchLava = true,
                discoverForestTemple = true,
                discoverScoob = true,
                discoverSkyIsland = true,
                activateAllPortals = false,
            }
        } -- TODO: Get real save data

        store:dispatch(PLAYER_ADD(player,saveData))

        api:initialPlayerState(player,saveData)
    end
end