local EquipmentBehavior = {}

function EquipmentBehavior.new(assetId)
    local self = setmetatable({},{__index = EquipmentBehavior})
    return self
end

function EquipmentBehavior:equipped(player)
    -- equipped to player
end

function EquipmentBehavior:unequipped()
    -- unequipped from player
end

function EquipmentBehavior:destroy()
    -- discarded after unequip
end

return EquipmentBehavior