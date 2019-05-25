local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")

return require(common.util:WaitForChild("compileSubmodules"))(script)