local equip = require(script.Parent:WaitForChild("equip"))
local unequip = require(script.Parent:WaitForChild("unequip"))

return function(equipment, action, cataId)
    equipment = equipment or {}
    equipment = equip(equipment, action, cataId)
    return unequip(equipment, action, cataId)
end