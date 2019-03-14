local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))
local Signal = require(lib:WaitForChild("Signal"))

local Achievements = require(script:WaitForChild("Achievements"))

local AchievementAwarder = {}
AchievementAwarder.achievements = {}
AchievementAwarder.achievementGet = Signal.new()

local function achievementAward(server, player,achievement)

    local state = server.store:getState()
    local playerState = state.players[player]
    if playerState then
        local stats = (playerState.stats or {})
        local playerAchievements = (stats.achievements or {})

        if not playerAchievements[achievement.id] then
            print("Achievement get! - "..player.Name.." : "..achievement.name)
            server.store:dispatch(Actions.ACHIEVEMENT_GET(player,achievement.id))
            if achievement.onAward then
                achievement.onAward(server,player)
            end
            if achievement.badgeId then
                if not BadgeService:UserHasBadgeAsync(player.UserId, achievement.badgeId) then
                    print("Awarded",achievement.badgeId,"to",player)
                    BadgeService:AwardBadge(player.UserId,achievement.badgeId)
                else
                    print("User already has badge.")
                end
            end
            AchievementAwarder.achievementGet:fire(player,achievement)
        end
    end
end

local function initAchievement(achievement,server)
    local awardFunc = function(player)
        achievementAward(server, player, achievement)
    end

    achievement.startListening(server, awardFunc)
end

local function playerJoined(server,player)
    -- check for and award any achievments that the player should have.
    for _, achievement in pairs(AchievementAwarder.achievements) do
        if achievement.queryComplete(server,player) then
            achievementAward(server,player,achievement)
        end
    end
end

function AchievementAwarder:start(server)

    Players.PlayerAdded:connect(function(player)
        playerJoined(server,player)
    end)

    -- init badges
    for id, achievement in pairs(Achievements) do
        initAchievement(achievement,server)
        AchievementAwarder.achievements[id] = achievement
    end
end

return AchievementAwarder