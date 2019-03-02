local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local Roact = require(lib:WaitForChild("Roact"))

local CoinCounter = require(component:WaitForChild("CoinCounter"))

local App = Roact.Component:extend("App")

function App:init(props)

end

function App:didMount()

end

function App:render()
    return Roact.createElement("Frame")
end

return App