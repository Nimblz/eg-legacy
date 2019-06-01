return {
    id = "effect_rainbowfire",
    type = "effect",
    name = "Rainbow Fire",
    description = "n/a",
    rarity = 101,
    hidden = false,
    thumbnailImage = "rbxassetid://3243264992",

    metadata = {
        effectType = "particle",
        effectInstances = { -- instances to clone into torso from assetmodels/effect
            "effect_fireblack",
            "effect_firewhite",
            "effect_firered",
            "effect_firegreen",
            "effect_fireblue",
            "effect_firecyan",
            "effect_fireyellow",
            "effect_firemagenta",
        }
    }
}