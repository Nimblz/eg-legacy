return function(state,action)
    state = state or {}
    local newState = {}

    for id,obtained in pairs(state) do
        newState[id] = obtained
    end

    if action.type == "ASSET_GIVE" then
        newState[action.assetId] = true
    end

    return newState
end