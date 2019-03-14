local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")
local commonReducers = common:WaitForChild("commonReducers")

local playerState = require(commonReducers:WaitForChild("playerState"))

return playerState