return function(state,action)
    state = state or nil

    if action.type == "UI_VIEW_SET" then
        return action.view
    end

    return state
end