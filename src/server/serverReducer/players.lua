return (function(state,action)
    state = state or {}

    if action.type == "PLAYER_ADD" then -- should be a thunk
        local player = action.player

        state[player] = action.saveData
    end

    if action.type == "PLAYER_REMOVE" then
        local player = action.player

        state[player] = nil
    end

    return state
end)