local children = script:GetChildren()
local products = {}
local productsById = {}
local DevProducts = {}

for _,child in pairs(children) do
    if child:IsA("ModuleScript") then
        local module = require(child)
        products[module.name] = module
        productsById[module.productId] = module
    end
end

function DevProducts.get(name)
    return products[name]
end

function DevProducts.getById(productId)
    return productsById[productId]
end

return DevProducts