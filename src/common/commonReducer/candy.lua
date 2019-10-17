return (function(state,action)
    state = state or 0

    if action.type == "CANDY_ADD" then
        return state + action.candy
    end

    if action.type == "CANDY_SUBTRACT" then
        return state - action.candy
    end

    return state
end)