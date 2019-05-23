-- renders yours and other egs equipment and handles their local usage effects

-- creates equipment object which handles behavior for the equipped asset.

-- things that require equipment object to be created
--  asset being equipped
--  player spawning

-- things that require equipment object to be destroyed
--  asset being unequipped
--  player being destroyed

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Signal = require(lib:WaitForChild("Signal"))

local EquipmentBehaviors = require(common:WaitForChild("EquipmentBehaviors"))
local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Selectors = require(common:WaitForChild("Selectors"))

local EquipmentBehavior = EquipmentBehaviors.EquipmentBehavior

local EquipmentReconciler = {}

local function getDiffs(t1,t2)
    local added, removed = {}, {}
    local t1Set, t2Set = {}, {}

    -- create t1 hash set
    for _,v in pairs(t1) do
        t1Set[v] = true
    end
    -- create t2 hash set and check against t1 set to find new elements
    for _,v in pairs(t2) do
        t2Set[v] = true
        -- do this here to cut out an extra for loop
        if not t1Set[v] then
            table.insert(added,v)
        end
    end
    -- check t1 against t2 set to find removed
    for _,v in pairs(t1) do
        if not t2Set[v] then
            table.insert(removed,v)
        end
    end

    return added,removed
end

function EquipmentReconciler:equipAsset(player, loader, assetId)
    local playerEquipmentBehaviors = self.equipmentBehaviors[player]
    if not playerEquipmentBehaviors then return end
    local equippedBehavior = playerEquipmentBehaviors[assetId]
    if equippedBehavior then return end
    local equipmentBehavior = EquipmentBehavior.new(loader, assetId)
    equipmentBehavior:equipped(player)

    playerEquipmentBehaviors[assetId] = equipmentBehavior

    self.equippedAsset:fire(player, assetId, equipmentBehavior)

    return equipmentBehavior
end

function EquipmentReconciler:unequipAsset(player,loader,assetId)
    local playerEquipmentBehaviors = self.equipmentBehaviors[player]
    if not playerEquipmentBehaviors then return end
    local equippedBehavior = playerEquipmentBehaviors[assetId]

    if equippedBehavior then
        self.unequippingAsset:fire(player, assetId, equippedBehavior)
        if equippedBehavior then
            equippedBehavior:unequipped()
            equippedBehavior:destroy()
        end
        playerEquipmentBehaviors[assetId] = nil
    end
end

function EquipmentReconciler:clearEquipped(player, loader)
    for assetId,_ in pairs(self.equipmentBehaviors[player] or {}) do
        self:unequipAsset(player,loader,assetId)
    end
    self.equipmentBehaviors[player] = {}
end

function EquipmentReconciler:getBehaviors(player)
    return self.equipmentBehaviors[player]
end


function EquipmentReconciler:playerCharacterSpawned(player, char, loader)
    self:clearEquipped(player) -- clear just in case equipment wasnt removed for some reason
    -- recreate and bind equipment for this player

    local equipment = Selectors.getEquipped(loader.store:getState(), player) or {}

    for _, cataEquipped in pairs(equipment) do
        for _, assetId in pairs(cataEquipped) do
            self:equipAsset(player, loader, assetId)
        end
    end
end

function EquipmentReconciler:playerAdded(player, loader)
    self.equipmentBehaviors[player] = {}

    self.characterEvents[player].adding = player.CharacterAdded:connect(function(char)
        char:WaitForChild("Humanoid")
        char:WaitForChild("Torso")
        char:WaitForChild("Head")
        char:WaitForChild("HumanoidRootPart")
        self:playerCharacterSpawned(player, char, loader)
    end)
    self.characterEvents[player].removing = player.CharacterRemoving:connect(function()
        self:clearEquipped(player, loader)
    end)

    if player.Character then
        self:playerCharacterSpawned(player, player.Character, loader)
    end
end

function EquipmentReconciler.new(loader)
    local self = setmetatable({},{__index = EquipmentReconciler})
    self.store = loader.store
    self.equipmentBehaviors = {} -- table of behavior tables indexed by players

    self.equippedAsset = Signal.new()
    self.unequippingAsset = Signal.new()
    self.characterEvents = {}

    Players.PlayerAdded:connect(function(player)
        self.characterEvents[player] = {adding = nil, removing = nil}
        self:playerAdded(player,loader)
    end)
    Players.PlayerRemoving:connect(function(player)
        for _,event in pairs(self.characterEvents[player]) do
            event:Disconnect()
        end
        self.equipmentBehaviors[player] = nil
        self.characterEvents[player] = nil
    end)

    -- equip everyone's initial equipment
    for _, player in pairs(Players:GetPlayers()) do
        self.characterEvents[player] = {adding = nil, removing = nil}
        self:playerAdded(player,loader)
    end

    self.store.changed:connect(function(newstate,oldstate)
        -- detect if hats have changed for each player
        for _, player in pairs(Players:GetPlayers()) do
            -- check each catagory for changes
            for cataId, _ in pairs(AssetCatagories.byId) do
                local oldEquipped = (Selectors.getEquipped(oldstate, player) or {})[cataId] or {}
                local newEquipped = (Selectors.getEquipped(newstate, player) or {})[cataId] or {}
                local added,removed = getDiffs(oldEquipped, newEquipped)

                for _,assetId in pairs(removed) do
                    self:unequipAsset(player,loader,assetId)
                end
                for _,assetId in pairs(added) do
                    self:equipAsset(player,loader,assetId)
                end
            end
        end
    end)

    return self
end

return EquipmentReconciler