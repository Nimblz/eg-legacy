return {
    -- Gameplay actions
    COIN_ADD = require(script.COIN_ADD),
    COIN_SUBTRACT = require(script.COIN_SUBTRACT),
    PLAYER_ADD = require(script.PLAYER_ADD),
    PLAYER_REMOVE = require(script.PLAYER_REMOVE),
    PORTAL_ACTIVATE = require(script.PORTAL_ACTIVATE),
    ACHIEVEMENT_GET = require(script.ACHIEVEMENT_GET),

    --INVENTORY_EQUIP = require(script.INVENTORY_EQUIP),
    --INVENTORY_UNEQUIP = require(script.INVENTORY_UNEQUIP),

    -- UI actions
    UI_VIEW_SET = require(script.UI_VIEW_SET),
    UI_CATAGORY_SET = require(script.UI_CATAGORY_SET)
}