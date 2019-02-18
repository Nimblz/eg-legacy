-- PLAYER_JOINED thunk

local PLAYER_ADD = require(script.Parent:WaitForChild("PLAYER_ADD"))

return function(player)
    return function(store)
        local saveData = {} -- TODO: Get save data

        store:dispatch(PLAYER_ADD(player,saveData))
    end
end