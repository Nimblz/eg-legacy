local AssetCatagories = require(script.Parent:WaitForChild("AssetCatagories"))
local Assets = require(script.Parent:WaitForChild("Assets"))

local ShopProducts = {}

local products = {}
local productsById = {}


local function isLessExpensive(asset1,asset2)
    return asset1.price < asset2.price
end

local function compileAllProducts()
    -- initialize catagory tables
    for _, catagory in pairs(AssetCatagories.getCatagories()) do
        products[catagory] = {}
    end

    -- add products
    for _,productModule in pairs(script:GetDescendants()) do
        if productModule:IsA("ModuleScript") then
            local product = require(productModule)
            local asset = Assets.get(product.id)
            assert(
                asset,
                ("Invalid asset %s in %s"):format(
                    product.id,
                    productModule:GetFullName())
            )
            local catagory = AssetCatagories.getCatagory(asset.type)
            assert(
                catagory,
                ("invalid type %s in asset %s"):format(
                    asset.type,
                    asset:GetFullName())
            )

            table.insert(products[catagory],product)
            productsById[product.id] = product
        end
    end

    -- sort catagories
    for _, subProducts in pairs(products) do
        table.sort(subProducts,isLessExpensive)
    end
end

function ShopProducts.get(id)
    return productsById[id]
end

function ShopProducts.getAll()
    return products
end

compileAllProducts()

return ShopProducts