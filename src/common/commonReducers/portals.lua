local reducerRoot = script.Parent

return function(state,action)
    state = state or {}
    local newState = {}

    for portal,active in pairs(state) do
        newState[portal] = active
    end

    if action.type == "PORTAL_ACTIVATE" then
        newState[action.portal] = true
    end

    return newState
end