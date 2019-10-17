local by = require(script.Parent.util:WaitForChild("by"))

local catagories = {
    {
        id = "halloween",
        image = "rbxassetid://4146266763", -- image used to represent this catagory
        name = "Halloween",
    },
    {
        id = "hat",
        image = "rbxassetid://3185662736", -- image used to represent this catagory
        name = "Hat",
    },
    {
        id = "face",
        image = "rbxassetid://3206646591",
        name = "Face",
    },
    {
        id = "material",
        image = "rbxassetid://3185662381",
        name = "Material",
    },
    {
        id = "effect",
        image = "rbxassetid://3185662510",
        name = "Effect",
    },
    {
        id = "pet",
        image = "rbxassetid://3210207976",
        name = "Pets",
    },
}

return {
    all = catagories,
    byId = by("id", catagories),
}