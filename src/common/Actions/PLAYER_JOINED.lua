-- PLAYER_JOINED thunk

local PLAYER_ADD = require(script.Parent:WaitForChild("PLAYER_ADD"))

return function(player)
    return function(store)
        local saveData = {
            portals = {
                red = true,
                orange = false,
                yellow = true,
                green = false,
                cyan = false,
                blue = true,
                purple = true
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
    end
end