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

    if action.type == "COIN_ADD" then
        local player = action.player
        state[player].stats = state[player].stats or {}
        state[player].stats.coins = (state[player].stats.coins or 0) + action.coins
    end

    if action.type == "COIN_REMOVE" then
        local player = action.player
        state[player].stats = state[player].stats or {}
        state[player].stats.coins = (state[player].stats.coins or 0) - action.coins
    end

    if action.type == "PORTAL_ACTIVATE" then
        local player = action.player
        state[player].portals = state[player].portals or {}
        state[player].portals[action.portal] = true
    end

    return state
end)