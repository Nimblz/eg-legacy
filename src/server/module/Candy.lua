-- server side coin tracking

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Promise = require(lib:WaitForChild("Promise"))
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Actions = require(common:WaitForChild("Actions"))
local Selectors = require(common:WaitForChild("Selectors"))
local Signal = require(lib:WaitForChild("Signal"))

local Candy = PizzaAlpaca.GameModule:extend("Candy")

local RESPAWN_TIME = 600

function Candy:create()
    self.collections = {}
    self.spawns = {}
    self.last5Secs = {}
end

function Candy:onPlayerJoin(player)
    self.collections[player] = {}
end

function Candy:onPlayerRemoving(player)
    self.collections[player] = nil
end

function Candy:bindRespawn(player,spawnPart)
    spawn(function()
        wait(RESPAWN_TIME)
        if self.collections[player] then
            self.collections[player][spawnPart] = false
            self.api:candyRespawn(player,spawnPart)
        end
    end)
end

function Candy:requestCollect(player,spawnPart)
    assert(typeof(spawnPart) == "Instance", "arg 2 must be a part, got:"..tostring(spawnPart))
    assert(spawnPart:IsA("BasePart"), "arg 2 must be a part, got:"..tostring(spawnPart))
    assert(self.spawns[spawnPart], "Invalid candy spawn")

    if not self.collections[player][spawnPart] then
        self.collections[player][spawnPart] = true

        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local dist = (root.Position-spawnPart.Position).Magnitude

        if dist > 40 then
            return -- too far away :O
        end

        self.store:dispatch(Actions.CANDY_ADD(player, 1))

        self.last5Secs[player] = (self.last5Secs[player] or 0) + 1
        if self.last5Secs[player] > 30 then
            player:Kick("Collecting candy too fast :( The server might be lagging. Or are you cheating?")
        end

        self:bindRespawn(player,spawnPart)
    end
end

function Candy:init()

    for _, instance in pairs(CollectionService:GetTagged("candy_spawn")) do
        self.spawns[instance] = instance
    end

    for _,player in pairs(Players:GetPlayers()) do
		self:onPlayerJoin(player)
	end

    Players.PlayerAdded:Connect(function(player) self:onPlayerJoin(player) end)
    Players.PlayerRemoving:Connect(function(player) self:onPlayerRemoving(player) end)

    -- every 5 secs clear the coin collected table
    spawn(function()
        while true do
            self.last5Secs = {}
            wait(5)
        end
    end)
end

function Candy:postInit()
    local apiWrapper = self.core:getModule("ServerApi")
    local storeContainer = self.core:getModule("StoreContainer")

    local function onAll(api, store)
        self.api = api
        self.store = store
    end

    Promise.all({
        apiWrapper:getApi(),
        storeContainer:getStore()
    }):andThen(function(resolved)
        return Promise.async(function(resolve,reject)
            onAll(unpack(resolved))
        end)
    end)
end

return Candy