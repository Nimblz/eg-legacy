local isFunc = require(script.Parent:WaitForChild("isFunc"))

return function (tbl,funcName,...)
    assert(type(tbl) == "table", "expected table in arg 1")
    assert(type(funcName) == "string", "expected function in arg 2")

    for _,module in pairs(tbl) do
        if isFunc(module[funcName]) then
            module[funcName](module,...)
        end
    end
end