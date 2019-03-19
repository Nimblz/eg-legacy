local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lib = ReplicatedStorage:WaitForChild("lib")

local PlayerDataStore
if game.PlaceId ~= 0 then
    PlayerDataStore = require(lib:WaitForChild("PlayerDataStore"))
end

return function(nextDispatch,store)
    return function(action)
        local prevState = store:getState()
        nextDispatch(action)
        if action.player then -- this action is modifying a players state
            local player = action.player
            local nextState = store:getState()
            local prevSaveTable = prevState.players[player]
            local playerSaveTable = nextState.players[player]
            if game.PlaceId ~= 0 then
                -- if prev save table is nil then the player has just joined, no need to save.
                if playerSaveTable and prevSaveTable then
                    local saveData = PlayerDataStore:GetSaveData(player)
                    saveData:Set("playerSaveTable", playerSaveTable)
                end
            end
        end
    end
end