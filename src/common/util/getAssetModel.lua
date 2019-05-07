local ReplicatedStorage = game:GetService("ReplicatedStorage")

local models = ReplicatedStorage:WaitForChild("assetmodels")

return function(id)
    return models:FindFirstChild(id,true)
end