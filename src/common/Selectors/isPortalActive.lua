local getPortals = require(script.Parent.getPortals)

return function(state,player,name)
    print(name)
    return getPortals(state,player)[name] == true
end