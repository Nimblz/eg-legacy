-- causes a part to spin and hover when you're near it, for coin animation
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local RECS = require(lib:WaitForChild("RECS"))

return RECS.defineComponent({
    name = "Spinny",
    generator = function()
        return {
            originalCFrame = nil,
            timeOffset = nil,
        }
    end,
})