local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local Selectors = require(common:WaitForChild("Selectors"))

local DataStore2
if game.PlaceId ~= 0 then
    DataStore2 = require(lib:WaitForChild("DataStore2"))
end

return function(nextDispatch,store)
    return function(action)
        local prevState = store:getState()
        nextDispatch(action)
        if action.player and action.type ~= "PLAYER_REMOVE" then -- this action is modifying a players state
            local player = action.player
            local nextState = store:getState()
            local prevSaveTable = Selectors.getPlayerState(prevState,player)
            local playerSaveTable = Selectors.getPlayerState(nextState,player)
            if game.PlaceId ~= 0 then
                -- if prev save table is nil then the player has just joined, no need to save.
                if playerSaveTable and prevSaveTable then
                    local saveStore = DataStore2("saveData",player)
                    saveStore:Set(playerSaveTable)
                end
            end
        end
    end
end