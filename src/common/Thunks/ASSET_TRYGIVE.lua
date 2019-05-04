local Assets = require(script.Parent.Parent:WaitForChild("Assets"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))

return function(assetId)
    return function(store)
        if Assets.byId[assetId] then
            store:dispatch(Actions.ASSET_GIVE(assetId))
        else
            warn(("Assset %s does not exist!"):format(assetId))
        end
    end
end