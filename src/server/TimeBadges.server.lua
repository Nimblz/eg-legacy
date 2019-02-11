local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")

local joinTimes = {}

local awarded = {}

local badges = {
    [1] = 2124454471,
    [60*5] = 2124454467,
    [60*30] = 2124454468,
    [60*60] = 2124454470,
}

local function awardBadge(player,badgeId)
    local playerId = player.UserId
    if not awarded[player] then
        awarded[player] = {}
    end
    if not awarded[player][badgeId] then
        awarded[player][badgeId] = true
        print("Awarded",badgeId,"to",player)
        BadgeService:AwardBadge(playerId,badgeId)
    end
end

Players.PlayerAdded:Connect(function(player)
    joinTimes[player] = tick()
end)

Players.PlayerRemoving:Connect(function(player)
    joinTimes[player] = nil
end)

while true do

    for _,player in pairs(Players:GetPlayers()) do
        for timeReq, badgeId in pairs(badges) do
            if tick() - joinTimes[player] > timeReq then
                awardBadge(player,badgeId)
            end
        end
    end

    wait(1)
end