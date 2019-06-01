return {
    id = "effect_redtrail",
    type = "effect",
    name = "Red Trail",
    description = "n/a",
    rarity = 50,
    hidden = false,
    thumbnailImage = "rbxassetid://3243285071",

    metadata = {
        effectType = "trail",
        effectInstances = { -- instances to clone into torso from assetmodels/effect
            "effect_trail",
        },
        effectColor3 = Color3.fromRGB(255,50,50),
    }
}