local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Selectors = require(common:WaitForChild("Selectors"))
local Actions = require(common:WaitForChild("Actions"))

local DAILY_LOGIN_BONUS = 15000000

local LoginBonus = PizzaAlpaca.GameModule:extend("LoginBonus")

local function shouldAwardBonus(state,player)
    local nowDate = os.date("!*t")
    local lastLoginSecs = Selectors.getLastLogin(state,player)
    if not lastLoginSecs then return true end -- must be first join
    local lastLoginDate = os.date("!*t",lastLoginSecs)

    if nowDate.day ~= lastLoginDate.day then
        return true
    end
end

function LoginBonus:onStore(store)
    local playerHandler = self.core:getModule("PlayerHandler")

    playerHandler.playerLoaded:connect(function(player)
        local state = store:getState()
        local shouldAward = shouldAwardBonus(state,player)
        if shouldAward then
            store:dispatch(Actions.COIN_ADD(player,DAILY_LOGIN_BONUS))
            print(("%s logged in for the first time today!"):format(tostring(player)))
            -- TODO: thank the player for joining with a notification
        end

        store:dispatch(Actions.LASTLOGIN_SET(player,os.time()))
    end)
end

function LoginBonus:postInit()
    local storeContainer = self.core:getModule("StoreContainer")

    storeContainer:getStore():andThen(function(newStore)
        self:onStore(newStore)
    end)
end

return LoginBonus