local ReplicatedStorage = game:GetService("ReplicatedStorage")

local models = ReplicatedStorage:WaitForChild("assetmodels")

local AssetCatagories = require(script.Parent:WaitForChild("AssetCatagories"))

local Assets = {}

local allAssets = {} -- table of catagory tables containing assets
local assetsById = {}


local function isLessRare(asset1,asset2)
    return asset1.rarity < asset2.rarity
end

local function compileAssets()
    -- initialize catagory tables
    for _, catagory in pairs(AssetCatagories.getAll()) do
        allAssets[catagory] = {}
    end

    -- add assets
    for _,assetModule in pairs(script:GetDescendants()) do
        if assetModule:IsA("ModuleScript") then
            local asset = require(assetModule)
            local catagory = AssetCatagories.get(asset.type)
            assert(
                catagory,
                ("invalid type %s in asset %s"):format(
                    asset.type,
                    assetModule:GetFullName()))

            table.insert(allAssets[catagory],asset)
            assetsById[asset.id] = asset
        end
    end

    -- sort catagories
    for _, assets in pairs(allAssets) do
        table.sort(assets,isLessRare)
    end
end

function Assets.get(id)
    return assetsById[id]
end

function Assets.getAll()
    return allAssets
end

function Assets.getModel(id)
    return models:FindFirstChild(id,true)
end

compileAssets()

return Assets