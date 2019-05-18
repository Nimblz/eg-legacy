local Selectors = require(script.Parent.Parent:WaitForChild("Selectors"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))

return function(player,assetId)
    return function(store)
        if Selectors.isOwned(store:getState(),player,assetId) then
            store:dispatch(Actions.ASSET_EQUIP(player,assetId))
        end
    end
end