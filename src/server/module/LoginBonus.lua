local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Selectors = require(common:WaitForChild("Selectors"))
local Actions = require(common:WaitForChild("Actions"))

local LoginBonus = {}

local function shouldAwardBonus(state,player)
    local nowDate = os.date("!*t")
    local lastLoginSecs = Selectors.getLastLogin(state,player)
    if not lastLoginSecs then return true end -- must be first join
    local lastLoginDate = os.date("!*t",lastLoginSecs)

    if nowDate.day ~= lastLoginDate.day then
        return true
    end
end

function LoginBonus:start(loader)
    local playerHandler = loader:getModule("PlayerHandler")
    local store = loader.store
    playerHandler.playerLoaded:connect(function(player)
        local state = store:getState()
        local shouldAward = shouldAwardBonus(state,player)
        if shouldAward then
            store:dispatch(Actions.COIN_ADD(player,2500))
            print(("%s logged in for the first time today!"):format(tostring(player)))
            -- TODO: thank the player for joining with a notification
        end

        store:dispatch(Actions.LASTLOGIN_SET(player,os.time()))
    end)
end

return LoginBonus