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

local AssetCatagories = require(common:WaitForChild("AssetCatagories"))
local Selectors = require(common:WaitForChild("Selectors"))

local EquipmentReconciler = {}

local equipmentBehaviors = {} -- table of behavior tables indexed by players

local function equipAsset(player, client, assetId)
    print("equipping:",assetId)
    local playerEquipmentBehaviors = equipmentBehaviors[player]
    local equipmentBehavior = {}
    --equipmentBehavior:equipped(player,client,assetid)
    playerEquipmentBehaviors[assetId] = equipmentBehavior

    return equipmentBehavior
end

local function unequipAsset(player,client,assetId)
    print("unequipping:",assetId)
    local playerEquipmentBehaviors = equipmentBehaviors[player]

    local equippedBehavior = playerEquipmentBehaviors[assetId]

    if equippedBehavior then
        -- destroy
    end

    playerEquipmentBehaviors[assetId] = nil
end

local function clearEquipped(player, client)
    print("clearing equipment")
    for assetId,_ in pairs(equipmentBehaviors[player]) do
        unequipAsset(player,client,assetId)
    end
    equipmentBehaviors[player] = {}
end

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

local function playerCharacterSpawned(player, char, client)
    clearEquipped(player) -- clear just in case equipment wasnt removed for some reason
    -- recreate and bind equipment for this player
    local equipment = Selectors.getEquipped(client.store:getState().gameState, player)

    for _, cataEquipped in pairs(equipment) do
        for _, assetId in pairs(cataEquipped) do
            print(" - "..assetId)
            equipAsset(player, client, assetId)
        end
    end
end

local function playerAdded(player, client)
    equipmentBehaviors[player] = {}
    player.CharacterAdded:connect(function(char)
        playerCharacterSpawned(player, char, client)
    end)
    player.CharacterRemoving:connect(function()
        clearEquipped(player, client)
    end)

    if player.Character then
        playerCharacterSpawned(player, player.Character, client)
    end
end

function EquipmentRenderer:start(client)
    local store = client.store

    Players.PlayerAdded:connect(function(player)
        playerAdded(player,client)
    end)
    Players.PlayerRemoving:connect(function(player)
        equipmentBehaviors[player] = nil
    end)

    -- equip everyone's initial equipment
    for _, player in pairs(Players:GetPlayers()) do
        playerAdded(player,client)
    end

    store.changed:connect(function(newstate,oldstate)
        -- detect if hats have changed for each player
        for _, player in pairs(Players:GetPlayers()) do
            -- check each catagory for changes
            for cataId, _ in pairs(AssetCatagories.byId) do
                local oldEquipped = Selectors.getEquipped(oldstate.gameState, player)[cataId] or {}
                local newEquipped = Selectors.getEquipped(newstate.gameState, player)[cataId] or {}
                local added,removed = getDiffs(oldEquipped, newEquipped)

                for _,assetId in pairs(removed) do
                    unequipAsset(player,client,assetId)
                end
                for _,assetId in pairs(added) do
                    equipAsset(player,client,assetId)
                end
            end
        end
    end)
end

return EquipmentReconciler