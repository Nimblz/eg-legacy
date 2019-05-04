local ReplicatedStorage = game:GetService("ReplicatedStorage")
local common = ReplicatedStorage:WaitForChild("common")

return require(common:WaitForChild("compileSubmodules"))(script)