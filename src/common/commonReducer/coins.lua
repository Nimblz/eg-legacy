return (function(state,action)
    state = state or 0

    if action.type == "COIN_ADD" then
        return state + action.coins
    end

    if action.type == "COIN_SUBTRACT" then
        return state - action.coins
    end

    return state
end)