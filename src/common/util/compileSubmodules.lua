return function(parent, recursive)
    local compiled = {}

    for _,module in pairs(recursive and parent:GetDescendants() or parent:GetChildren()) do
        if module:IsA("ModuleScript") then
            compiled[module.Name] = require(module)
        end
    end

    return compiled
end