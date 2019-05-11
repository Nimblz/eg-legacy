local getInventory = require(script.Parent.getInventory)

return function(state,player,assetId)
    return getInventory(state,player)[assetId] == true
end