local Achievements = {
    -- Portal_Activated = require(script:WaitForChild("Portal_Activated")),
    -- Portal_AllActivated = require(script:WaitForChild("Portal_AllActivated")),
    -- Walked_500Miles = require(script:WaitForChild("Walked_500Miles")),
    -- Walked_500More = require(script:WaitForChild("Walked_500More")),
}

-- coin achievements 100 to 1,000,000 by power of 10
for magnitude = 2,6 do
    local quantity = math.pow(10,magnitude)
    local newCoinAchievement = require(script:WaitForChild("coinAchievementMaker"))(quantity)
    Achievements["Coins_"..quantity] = newCoinAchievement
end

return Achievements