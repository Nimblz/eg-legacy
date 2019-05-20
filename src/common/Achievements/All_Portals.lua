local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")
local portalModels = Workspace:WaitForChild("portals"):WaitForChild("portals2")

local Selectors = require(common:WaitForChild("Selectors"))

local portalNames = {}
-- compile names
for _,portalModel in pairs(portalModels:GetChildren()) do
    table.insert(portalNames,portalModel.Name)
end

local function queryComplete(server,player)
    local state = server.store:getState()

    local portals = Selectors.getPortals(state,player)
    if not portals then return false end
    for _,portal in pairs(portalNames) do
        if not portals[portal] then
            return false
        end
    end
    return true
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