return function(state,action)
    state = state or 0

    if action.type == "COIN_ADD" then
        state = state + action.coins
        print("Coin added")
    end
    if action.type == "COIN_REMOVE" then
        state = state - action.coins
    end

    print(state)

    return state
end