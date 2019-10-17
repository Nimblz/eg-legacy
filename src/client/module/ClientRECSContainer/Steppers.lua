local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local RECS = require(lib:WaitForChild("RECS"))
local Systems = require(script.Parent:WaitForChild("Systems"))

-- registration
-- services will be registered in the order given
return {
    RECS.event(game:GetService("RunService").RenderStepped, {
        Systems.SpinnySystem,
    }),
}