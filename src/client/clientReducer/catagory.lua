return function(state,action)
    state = state or "hats"

    if action.type == "UI_CATAGORY_SET" then
        return action.catagory
    end

    return state
end