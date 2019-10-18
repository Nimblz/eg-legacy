local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))

local Music = PizzaAlpaca.GameModule:extend("Music")

function Music:preInit()
end

function Music:init()
end

function Music:postInit()
    local music = Instance.new("Sound")
    music.Volume = 0.3
    music.Parent = workspace
    spawn(function()
        local songs = {
            "rbxassetid://1842407817",
            "rbxassetid://678930213",
            "rbxassetid://4106215460",
            "rbxassetid://3376927353",
            "rbxassetid://138123994",
            "rbxassetid://1845450718",
            "rbxassetid://1845385785",
        }
        local rare = "rbxassetid://3377348794"
        while true do
            for _, songId in ipairs(songs) do
                local useRare = math.random(1000) < 5
                music.SoundId = useRare and rare or songId
                music:Play()
                music.Ended:Wait()
                music:Stop()
            end
        end
	end)
end

return Music