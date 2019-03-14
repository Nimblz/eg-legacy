local Players = game:GetService("Players")



return function(timeRequirement,name,desc,badgeId)

    local joinTimes = {}
    -- function that returns true if a player has completed this objective
    local function queryComplete(server,player)
        return (joinTimes[player] ~= nil) and (tick() - joinTimes[player] > timeRequirement)
    end

    return {
        id = "SessionLength_"..timeRequirement,
        name = name,
        desc = desc,
        badgeId = badgeId,
        startListening = (function(server, awardBadge)
            Players.PlayerAdded:Connect(function(player)
                joinTimes[player] = tick()
            end)

            Players.PlayerRemoving:Connect(function(player)
                joinTimes[player] = nil
            end)

            spawn(function()
                while true do
                    for _,player in pairs(Players:GetPlayers()) do
                        if joinTimes[player] then
                            if tick() - joinTimes[player] > timeRequirement then
                                awardBadge(player)
                            end
                        end
                    end

                    wait(1)
                end
            end)
        end),
        queryComplete = queryComplete,
    }
end