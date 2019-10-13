local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Promise = require(lib:WaitForChild("Promise"))
local Selectors = require(common:WaitForChild("Selectors"))
local Actions = require(common:WaitForChild("Actions"))
local Thunks = require(common:WaitForChild("Thunks"))

local Signal = require(lib:WaitForChild("Signal"))

local PlayerHandler = PizzaAlpaca.GameModule:extend("PlayerHandler")
PlayerHandler.playerLoaded = Signal.new()

local function playerAdded(player,store,api)
    print("Loading data for: ", player)
    store:dispatch(Thunks.PLAYER_JOINED(player,api))
    wait(0.5)
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"baseball2007"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"bandit"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"baconhair"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"arrow"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"footballHelmet"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"material_pastelred"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"material_pasteldeepgreen"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"material_pastelcyan"))
    store:dispatch(Thunks.ASSET_TRYGIVE(player,"material_pastelyellow"))
    --store:dispatch(Thunks.ASSET_TRYGIVE(player,"10mil"))
    --store:dispatch(Thunks.ASSET_TRYGIVE(player,"pet_partyball"))
    PlayerHandler.playerLoaded:fire(player)
end

local function playerLeaving(player,store)
	store:dispatch(Thunks.PLAYER_LEAVING(player))
end

function PlayerHandler:onStoreAndApi(store,api)
    Players.PlayerAdded:Connect(function(player)
        playerAdded(player,store,api)
    end)

    Players.PlayerRemoving:Connect(function(player)
        playerLeaving(player,store)
    end)

    for _,player in pairs(Players:GetPlayers()) do
        playerAdded(player,store,api)
    end
end

function PlayerHandler:postInit()
    local apiWrapper = self.core:getModule("ServerApi")
    local storeContainer = self.core:getModule("StoreContainer")

    Promise.all({
        storeContainer:getStore(),
        apiWrapper:getApi()
    }):andThen(function(resolved)
        return Promise.async(function(resolve,reject)
            self:onStoreAndApi(unpack(resolved))
        end)
    end)
end

function PlayerHandler:getLoadedPlayers(store)
    local loadedPlayers = {}


    for _,player in pairs(Players:GetPlayers()) do
        local playerState = Selectors.getPlayerState(store:getState(), player)
        if playerState then
            table.insert(loadedPlayers,player)
        end
    end

    return loadedPlayers
end

return PlayerHandler