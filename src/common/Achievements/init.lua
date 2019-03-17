local Achievements = {
    -- Portal_Activated = require(script:WaitForChild("Portal_Activated")),
    -- Portal_AllActivated = require(script:WaitForChild("Portal_AllActivated")),
    -- Walked_500Miles = require(script:WaitForChild("Walked_500Miles")),
    -- Walked_500More = require(script:WaitForChild("Walked_500More")),
    SessionLength_Joined = require(script:WaitForChild("timeAchievementMaker"))(
        0,
        "you played",
        "this is a badge of shame.",
        2124454471
    ),
    SessionLength_5Min = require(script:WaitForChild("timeAchievementMaker"))(
        60*5,
        "5 mins",
        "spend 5 mins in eg in one session",
        2124454467
    ),
    SessionLength_30Min = require(script:WaitForChild("timeAchievementMaker"))(
        60*30,
        "30 mins",
        "30 mins straight in eg. are you okay?",
        2124454468
    ),
    SessionLength_60Min = require(script:WaitForChild("timeAchievementMaker"))(
        60*60,
        "1 hour",
        "an hour straight in eg! you can stop playing! there's not even anything fun to do!",
        2124454470
    ),
    All_Portals = require(script:WaitForChild("All_Portals")),
}
--[[ times
    [1] = 2124454471,
    [60*5] = 2124454467,
    [60*30] = 2124454468,
    [60*60] = 2124454470,
]]

-- coin achievements 100 to 1,000,000 by power of 10
local coinBadges = {
    [10^2] = 2124456119,
    [10^3] = 2124456120,
}
for magnitude = 2,6 do
    local quantity = math.pow(10,magnitude)
    local newCoinAchievement = require(script:WaitForChild("coinAchievementMaker"))(quantity,coinBadges[quantity])
    Achievements["Coins_"..quantity] = newCoinAchievement
end

return Achievements