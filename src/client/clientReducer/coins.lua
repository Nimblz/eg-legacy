return function(state,action)
    state = state or 0

    if action.type == "COIN_ADD" then
        state = state + action.coins
    end
    if action.type == "COIN_REMOVE" then
        state = state - action.coins
    end

    return state
end