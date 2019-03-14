local reducerRoot = script.Parent

return function(state,action)
    state = state or {}

    if action.type == "PORTAL_ACTIVATE" then
        state[action.portal] = true
    end

    return state
end