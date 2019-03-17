local Workspace = game:GetService("Workspace")

local portalModels = Workspace:WaitForChild("portals"):WaitForChild("portals2")

local portalNames = {}

-- compile names
for _,portalModel in pairs(portalModels:GetChildren()) do
    table.insert(portalNames,portalModel.Name)
end

local function queryComplete(server,player)
    local state = server.store:getState()
    local playerState = state.players[player]
    if playerState then
        local portals = playerState.portals or {}

        for _,portal in pairs(portalNames) do
            if not portals[portal] then
                return false
            end
        end
        return true
    end
    return false
end

return {
    id = "All_Portals",
    name = "All Portals",
    desc = "Activate all portals.",
    badgeId = 2124456121,
    startListening = (function(server, awardBadge)
        local PortalsListener = server:getModule("PortalsListener")

        PortalsListener.portalActivated:connect(function(player,portal)
            if queryComplete(server, player) then
                awardBadge(player)
            end
        end)
    end),
    queryComplete = queryComplete,
}