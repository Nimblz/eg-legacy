return function(parent, recursive)
    local compiled = {}

    for _,module in pairs(recursive and parent:GetDescendants() or parent:GetChildren()) do
        if module:IsA("ModuleScript") then
            local required = require(module)
            table.insert(compiled, required)
        end
    end

    return compiled
end