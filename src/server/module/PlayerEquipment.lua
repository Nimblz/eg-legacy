-- handles equipment on the server, notifies clients of equipment changes

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local object = common:WaitForChild("object")
local EquipmentReconciler = require(object:WaitForChild("EquipmentReconciler"))

local PlayerEquipment = {}
local equipmentReconciler

function PlayerEquipment:start(loader)
    equipmentReconciler = EquipmentReconciler.new(loader)
end

return PlayerEquipment