local by = require(script.Parent.util:WaitForChild("by"))

local catagories = {
    {
        id = "hat",
        image = "rbxassetid://3046056467", -- image used to represent this catagory
        name = "Hat",
        maxEquipped = 3,
    },
    {
        id = "face",
        image = "rbxassetid://3046056467",
        name = "Face",
        maxEquipped = 1,
    },
    {
        id = "material",
        image = "rbxassetid://3046056467",
        name = "Material",
        maxEquipped = 1,
    },
    {
        id = "effect",
        image = "rbxassetid://3046056467",
        name = "Effect",
        maxEquipped = 2,
    },
    {
        id = "tool",
        image = "rbxassetid://3046056467",
        name = "Tool",
        maxEquipped = 3,
    },
    {
        id = "ability",
        image = "rbxassetid://3046056467",
        name = "Ability",
        maxEquipped = 99,
    },
}

return {
    all = catagories,
    byId = by("id", catagories),
}