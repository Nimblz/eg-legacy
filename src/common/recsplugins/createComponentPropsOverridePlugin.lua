local errors = {
    nonFunctionalReturn = "Component props override module for [%s] does not return a function!"
}

local function createComponentPropsOverridePlugin()
    local componentPropsOverridePlugin = {}

    function componentPropsOverridePlugin:componentAdded(core, entity, component)
        if not typeof(entity) == "Instance" then return end -- entity is not an instance, not interested.
        local componentPropsModule = entity:FindFirstChild("ComponentProps")
        if not componentPropsModule then return end -- doesnt exist, not interested
        if componentPropsModule:IsA("ObjectValue") then componentPropsModule = componentPropsModule.Value end
        if not componentPropsModule then return end
        if not componentPropsModule:IsA("ModuleScript") then return end -- not a module script, not interested.

        -- type checkingggg
        local componentPropsOverrideFunc = require(componentPropsModule)
        assert( typeof(componentPropsOverrideFunc) == "function",
            errors.nonFunctionalReturn:format(entity:GetFullName())
        )

        -- create the new override table
        local componentPropsOverride = componentPropsOverrideFunc()
        local thisComponentOverride = componentPropsOverride[component.className]
        if not thisComponentOverride then return end

        -- assign each key,value of the new override to the component
        for key,value in pairs(thisComponentOverride) do
            component[key] = value
        end
    end

    return componentPropsOverridePlugin
end

return createComponentPropsOverridePlugin