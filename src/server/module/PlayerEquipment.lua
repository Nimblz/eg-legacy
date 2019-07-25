-- handles equipment on the server, notifies clients of equipment changes

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")
local object = common:WaitForChild("object")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local EquipmentReconciler = require(object:WaitForChild("EquipmentReconciler"))

local PlayerEquipment = PizzaAlpaca.GameModule:extend("PlayerEquipment")

function PlayerEquipment:postInit()
    local storeContainer = self.core:getModule("StoreContainer")
    local store = storeContainer:getStore()

    local coreHackStructure = setmetatable({
        store = store
    }, {__index = self.core})
    self.equipmentReconciler = EquipmentReconciler.new(coreHackStructure)
end

return PlayerEquipment