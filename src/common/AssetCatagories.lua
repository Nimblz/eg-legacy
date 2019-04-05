local AssetCatagories = {}

local catagories = {
    hat = {
        id = "hat",
        image = "rbxassetid://0", -- image used to represent this catagory
        name = "Hat"
    },
    face = {
        id = "face",
        image = "rbxassetid://0",
        name = "Face"
    },
    material = {
        image = "rbxassetid://0",
        name = "Material"
    },
    tool = {
        image = "rbxassetid://0",
        name = "Tool"
    },
    ability = {
        image = "rbxassetid://0",
        name = "Ability"
    },
}

function AssetCatagories.getCatagory(id)
    return catagories[id]
end

function AssetCatagories.getCatagories()
    return catagories
end

return AssetCatagories