return function(keyName, tbl)
    assert(typeof(keyName)=="string", "Arg 1 must be a string, got "..typeof(keyName))
    assert(typeof(tbl)=="table", "Arg 2 must be a table, got"..typeof(tbl))

    local new = {}

    for idx,v in ipairs(tbl) do
        if v[keyName] ~= nil then
            new[v[keyName]] = v
        else
            warn(("item %s at [%d] has no key %s"):format(tostring(v), idx, tostring(keyName)))
        end
    end

    return new
end