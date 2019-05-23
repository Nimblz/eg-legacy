local EquipmentBehavior = require(script.Parent.EquipmentBehavior)
local SpeedyBehavior = setmetatable({},{__index = EquipmentBehavior})

function SpeedyBehavior.new(assetId)
    local self = setmetatable({},{__index = SpeedyBehavior})
    return self
end

function SpeedyBehavior:equipped(player)
    -- equipped to player
end

function SpeedyBehavior:applyStats(stats)
    local newStats = EquipmentBehavior.applyStats(self,stats)

    newStats.walkspeed = stats.walkspeed * 2

    return newStats
end

function SpeedyBehavior:unequipped()
    -- unequipped from player
end

function SpeedyBehavior:destroy()
    -- discarded after unequip
end

return SpeedyBehavior