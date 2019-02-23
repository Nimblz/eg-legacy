local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")
local Workspace = game:GetService("Workspace")

local TimeBadges = {}

local joinTimes = {}

local badges = {
    [1] = 2124454471,
    [60*5] = 2124454467,
    [60*30] = 2124454468,
    [60*60] = 2124454470,
}

local function awardBadge(player,badgeId)
    local playerId = player.UserId

    if not BadgeService:UserHasBadgeAsync(player.UserId, badgeId) then
        print("Awarded",badgeId,"to",player)
        BadgeService:AwardBadge(playerId,badgeId)
    end
end

function TimeBadges:init()
    Players.PlayerAdded:Connect(function(player)
        joinTimes[player] = Workspace.DistributedGameTime
    end)

    Players.PlayerRemoving:Connect(function(player)
        joinTimes[player] = nil
    end)

    spawn(function()
        while true do

            for _,player in pairs(Players:GetPlayers()) do
				if joinTimes[player] and Workspace.DistributedGameTime then
	                for timeReq, badgeId in pairs(badges) do
	                    if Workspace.DistributedGameTime - joinTimes[player] > timeReq then
	                        awardBadge(player,badgeId)
	                    end
	                end
				end
            end

            wait(1)
        end
    end)
end

return TimeBadges