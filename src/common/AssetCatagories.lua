local AssetCatagories = {}
local byId = {}

local catagories = {
    {
        id = "hat",
        image = "rbxassetid://3046056467", -- image used to represent this catagory
        name = "Hat"
    },
    {
        id = "face",
        image = "rbxassetid://3046056467",
        name = "Face"
    },
    {
        id = "material",
        image = "rbxassetid://3046056467",
        name = "Material"
    },
    {
        id = "effect",
        image = "rbxassetid://3046056467",
        name = "Effect"
    },
    {
        id = "tool",
        image = "rbxassetid://3046056467",
        name = "Tool"
    },
    {
        id = "ability",
        image = "rbxassetid://3046056467",
        name = "Ability"
    },
}

-- index by id
for _,catagory in pairs(catagories) do
    byId[catagory.id] = catagory
end

function AssetCatagories.get(id)
    return byId[id]
end

function AssetCatagories.getAll()
    return catagories
end

function AssetCatagories.getAllbyId()
    return byId
end

return AssetCatagories