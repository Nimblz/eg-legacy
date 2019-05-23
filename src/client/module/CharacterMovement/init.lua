-- handles movement abilities (double jump, flight, swim, walkspeed, ice slip, dash, rolling)
-- prototype, i dunno how to structure this so here i go!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local CharacterMovement = {}

local MovementModules = require(common.util:WaitForChild("compileSubmodules"))(script)

local function statsUpdate(newStats)
    for _,module in pairs(MovementModules) do
        module:statsUpdate(newStats)
    end
end

function CharacterMovement:start(loader)
    for id,module in pairs(MovementModules) do
        print("* Starting movement module:",id)
        module:init(loader)
    end

    LocalPlayer.CharacterAdded:connect(function(newChar)
        for _,module in pairs(MovementModules) do
            module:characterSpawned(newChar)
        end
    end)

    if LocalPlayer.Character then
        for _,module in pairs(MovementModules) do
            module:characterSpawned(LocalPlayer.Character)
        end
    end
end

return CharacterMovement