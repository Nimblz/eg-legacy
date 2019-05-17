local equip = require(script.Parent:WaitForChild("equip"))
local unequip = require(script.Parent:WaitForChild("unequip"))

return function(equipment, action, cataId)
    equipment = equipment or {}
    local newEquipment = equip(equipment, action, cataId)
    return unequip(newEquipment, action, cataId)
end