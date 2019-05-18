local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local models = ReplicatedStorage:WaitForChild("assetmodels")

local Assets = require(common:WaitForChild("Assets"))

local cataFuncs = {
    hat = function(id, asset)
        return models:WaitForChild("hats"):FindFirstChild(id)
    end,
    material = function(id, asset)
        local materialSample = models:WaitForChild("materials").materialbase:Clone()

        materialSample.Color = asset.metadata.color or BrickColor.new("White").Color
        materialSample.Material = asset.metadata.material or Enum.Material.Plastic

        return materialSample
    end
}

return function(id)
    local asset = Assets.byId[id]
    assert(asset, "Invalid asset id, cannot produce model")
    local type = asset.type
    assert(type, "Asset must have a type to produce model, got nil")
    assert(cataFuncs[type], "Model rendering for this type not implemented yet. :(")
    return cataFuncs[type](id,asset)
end