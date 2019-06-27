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

local function userHasBadge(player,id)
    badgeAwardedCache[player] = badgeAwardedCache[player] or {}
    if badgeAwardedCache[player][id] then return true end
    local hasBadge
    local success, msg = false, ""
    local tries = 0
    while not success and tries < 10 do
        success, msg = pcall(function()
            tries = tries+1
            hasBadge = BadgeService:UserHasBadgeAsync(player.UserId,id)
        end)
        wait(0.5)
    end
    if not success then
        warn("unable to retrieve badge ownership status for:",player.Name)
        warn("returning as if they dont have the badge.")
        return false
    end
    return hasBadge
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

    if achievement.badgeId then
        if not userHasBadge(player,achievement.badgeId) then
            print("Awarded",achievement.badgeId,"to",player)
            BadgeService:AwardBadge(player.UserId,achievement.badgeId)
            badgeAwardedCache[player][achievement.badgeId] = true
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
    local state = server.store:getState()
    local playerState = state.players[player] or {}
    for _, achievement in pairs(AchievementAwarder.achievements) do
        local stats = (playerState.stats or {})
        local playerAchievements = (stats.achievements or {})

        -- retroactive badge awarding
        local missingBadge = not userHasBadge(player,achievement.badgeId) and playerAchievements[achievement.id]

        if achievement.queryComplete(server,player) or missingBadge then
            print(("Loaded player %s meets requirements for: %s"):format(player.Name,achievement.name))
            achievementAward(server,player,achievement)
            badgeAwardedCache[player][achievement.badgeId] = true
        end
    end
end

function AchievementAwarder:start(server)

    -- init cheevos
    for id, achievement in pairs(Achievements) do
        initAchievement(achievement,server)
        AchievementAwarder.achievements[id] = achievement
    end

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