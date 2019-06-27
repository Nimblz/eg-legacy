local Achievements = {
    -- Portal_Activated = require(script:WaitForChild("Portal_Activated")),
    -- Portal_AllActivated = require(script:WaitForChild("Portal_AllActivated")),
    -- Walked_500Miles = require(script:WaitForChild("Walked_500Miles")),
    -- Walked_500More = require(script:WaitForChild("Walked_500More")),
    SessionLength_Joined = require(script:WaitForChild("timeAchievementMaker"))(
        0,
        "you played",
        "this is a badge of shame.",
        2124454471 -- badgeid
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

    Coins_5000 = require(script:WaitForChild("coinAchievementMaker"))(5000,2124456119),
    Coins_100000 = require(script:WaitForChild("coinAchievementMaker"))(100000,2124456120),
}
--[[ times
    [1] = 2124454471,
    [60*5] = 2124454467,
    [60*30] = 2124454468,
    [60*60] = 2124454470,
]]

return Achievements