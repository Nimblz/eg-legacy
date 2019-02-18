local children = script:GetChildren()
local products = {}
local DevProducts = {}

for _,child in pairs(children) do
    if child:IsA("ModuleScript") then
        local module = require(child)
        products[module.name] = module
    end
end

function DevProducts.get(name)
    return products[name]
end

return DevProducts