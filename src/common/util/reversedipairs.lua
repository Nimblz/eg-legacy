-- https://stackoverflow.com/questions/41349526/how-to-iterate-lua-table-from-end

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end

return function(t)
    return reversedipairsiter, t, #t + 1
end