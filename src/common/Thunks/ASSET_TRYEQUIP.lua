local Selectors = require(script.Parent.Parent:WaitForChild("Selectors"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))

return function(assetId)
    return function(store)
        if Selectors.isOwned(store,assetId) then
            store:dispatch(Actions.ASSET_EQUIP(assetId))
        else
            warn(("Asset %s is not owned!"):format(assetId))
        end
    end
end