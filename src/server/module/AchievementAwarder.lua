local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Actions = require(common:WaitForChild("Actions"))
local Selectors = require(common:WaitForChild("Selectors"))
local Signal = require(lib:WaitForChild("Signal"))
local Promise = require(lib:WaitForChild("Promise"))

local Achievements = require(common:WaitForChild("Achievements"))

local AchievementAwarder = {}
AchievementAwarder.achievements = {}
AchievementAwarder.achievementGet = Signal.new()

local badgeAwardedCache = {}

local function queryPlayerHasBadge(player,badgeId)
    return Promise.new(function(resolve,reject)
        spawn(function()
            local hasBadge = nil
            while hasBadge == nil do
                pcall(function()
                    hasBadge = BadgeService:UserHasBadgeAsync(player.UserId, badgeId)
                end)
                if hasBadge == nil then
                    wait(1+math.random()*3)
                end
            end

            resolve(hasBadge)
        end)
    end)
end

local function achievementAward(server, player,achievement)

    local state = server.store:getState()
    local playerAchievements = Selectors.getAchievements(state,player)
    if not playerAchievements then return end

    if not playerAchievements[achievement.id] then
        print("Achievement get! - "..player.Name.." : "..achievement.name)
        server.store:dispatch(Actions.ACHIEVEMENT_GET(player,achievement.id))
        if achievement.onAward then
            achievement.onAward(server,player)
        end
        AchievementAwarder.achievementGet:fire(player,achievement)
    end

    badgeAwardedCache[player] = badgeAwardedCache[player] or {}
    if achievement.badgeId and not badgeAwardedCache[player][achievement.badgeId] then
        queryPlayerHasBadge(player,achievement.badgeId):andThen(function(hasBadge)
            if not hasBadge then
                print("Awarded",achievement.badgeId,"to",player)
                BadgeService:AwardBadge(player.UserId,achievement.badgeId)
                badgeAwardedCache[player][achievement.badgeId] = true
            else
                badgeAwardedCache[player][achievement.badgeId] = true
            end
        end)
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
    local state = server.store:getState()
    local playerState = state.players[player] or {}
    for _, achievement in pairs(AchievementAwarder.achievements) do
        local stats = (playerState.stats or {})
        local playerAchievements = (stats.achievements or {})

        -- retroactive badge awarding
        queryPlayerHasBadge(player,achievement.badgeId):andThen(function(hasBadge)
            local missingBadge = (
                achievement.badgeId and -- achievement has badge
                playerAchievements[achievement.id] and -- player has earned in past
                not hasBadge -- player has not been awarded badge
            )
            if achievement.queryComplete(server,player) or missingBadge then
                print(("Loaded player %s meets requirements for: %s"):format(player.Name,achievement.name))
                achievementAward(server,player,achievement)
            end
        end)
    end
end

function AchievementAwarder:start(server)

    -- init cheevos
    print("Initializing Achievements [[")
    for id, achievement in pairs(Achievements) do
        print((" - %s"):format(id))
        initAchievement(achievement,server)
        AchievementAwarder.achievements[id] = achievement
    end
    print("]]")

    server:getModule("PlayerHandler").playerLoaded:connect(function(player)
        playerJoined(server,player)
    end)

    for _,player in pairs(server:getModule("PlayerHandler"):getLoadedPlayers(server.store)) do
        spawn(function()
            playerJoined(server,player)
        end)
    end
end

return AchievementAwarder