return (function(state,action)
    state = state or {}
    local newState = {}

    for id,achievement in pairs(state) do
        newState[id] = achievement
    end

    if action.type == "ACHIEVEMENT_GET" then
        newState[action.achievementId] = true
    end

    return newState
end)