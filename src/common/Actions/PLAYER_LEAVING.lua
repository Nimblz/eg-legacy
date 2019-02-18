-- PLAYER_LEAVING thunk

local PLAYER_REMOVE = require(script.Parent:WaitForChild("PLAYER_REMOVE"))

return function(player)

    return function(store)
        -- TODO: Actually save data

        store:dispatch(PLAYER_REMOVE(player))
    end
end