return function(equipped,action)
    equipped = equipped or {}

    if action.type == "ASSET_UNEQUIP" then
        local newEquipped = {}
        for idx, value in ipairs(equipped) do
            if value == action.assetId then
                target = idx
            end
        end
    end
    return equipped
end