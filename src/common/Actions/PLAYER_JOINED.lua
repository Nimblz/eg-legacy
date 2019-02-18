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
            }
        } -- TODO: Get real save data

        store:dispatch(PLAYER_ADD(player,saveData))
    end
end