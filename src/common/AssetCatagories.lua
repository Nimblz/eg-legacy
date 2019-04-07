local AssetCatagories = {}
local byId = {}

local catagories = {
    {
        id = "hat",
        image = "rbxassetid://0", -- image used to represent this catagory
        name = "Hat"
    },
    {
        id = "face",
        image = "rbxassetid://0",
        name = "Face"
    },
    {
        id = "material",
        image = "rbxassetid://0",
        name = "Material"
    },
    {
        id = "tool",
        image = "rbxassetid://0",
        name = "Tool"
    },
    {
        id = "ability",
        image = "rbxassetid://0",
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