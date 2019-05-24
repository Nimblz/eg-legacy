local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local MinsInDay = 15
local MinsInNight = 5

local DayNight = {}

function DayNight:init()

end

function DayNight:start(client)
    RunService.Stepped:connect(function()
        local scaledToDay = tick() * 60 * 24 -- 1 sec 1 day
        local scaledToMins = scaledToDay / (60 * MinsInDay) -- time for full cycle
        local minsAfterMidnight = scaledToMins % 1440
        Lighting:SetMinutesAfterMidnight(minsAfterMidnight)
    end)
end

return DayNight