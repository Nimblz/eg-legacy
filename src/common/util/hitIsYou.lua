local Players = game:GetService("Players")

local function hitIsYou(hit)
    return Players:GetPlayerFromCharacter(hit.Parent) == Players.LocalPlayer
end

return hitIsYou