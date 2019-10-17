-- increments score on touch, use in combination with spinner! :D entity composition!!
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local RECS = require(lib:WaitForChild("RECS"))

return RECS.defineComponent({
    name = "CollectableItem",
    generator = function()
        return {
            originalCFrame = nil,
            timeOffset = nil,
            spawnPart = nil,
            itemId = "child",
        }
    end,
})