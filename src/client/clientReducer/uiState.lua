local view = require(script.Parent:WaitForChild("view"))
local catagory = require(script.Parent:WaitForChild("catagory"))

return function(state,action)
    state = state or {}
    return {
        view = view(state.view,action),
        catagory = catagory(state.catagory,action),
    }
end