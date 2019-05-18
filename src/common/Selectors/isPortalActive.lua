local getPortals = require(script.Parent.getPortals)

return function(state,player,name)
    return getPortals(state,player)[name] == true
end