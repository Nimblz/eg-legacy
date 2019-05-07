local by = require(script.Parent.util:WaitForChild("by"))

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

return {
    all = catagories,
    byId = by("id", catagories),
}