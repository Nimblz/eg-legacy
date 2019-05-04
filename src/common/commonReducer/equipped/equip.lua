return function(equipped, max, action)
    equipped = equipped or {}

    if action.type == "ASSET_EQUIP" then
        local newEquipped = {}

        newEquipped[1] = action.assetId
        for i = 1, math.min(#equipped, max - 1) do
            newEquipped[i + 1] = equipped[i]
        end

        return newEquipped
    end

    return equipped
end