local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local model = ReplicatedStorage:WaitForChild("model")
local coinModel = model:WaitForChild("CoinModel")

local Coin = {}

function Coin.new(spawnPart)
    local self = setmetatable({},{__index = Coin})

    self.ViewModel = coinModel:Clone()

    self.ViewModel.CFrame = spawnPart.CFrame

    self.ViewModel.Parent = Workspace

    return self
end

function Coin:collect()
    -- fire remote then hide coin
end

function Coin:hide()

end

function Coin:show()

end