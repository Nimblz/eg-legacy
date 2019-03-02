return (function(state,action)
    state = state or {}

    if action.type == "ACHIEVEMENT_GET" then
        state[action.achievementId] = true
    end

    return state
end)