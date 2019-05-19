return (function(state,action)
    if action.type == "LASTLOGIN_SET" then
        return action.date
    end

    return state
end)