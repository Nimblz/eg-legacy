local function createInjectorPlugin(key,value)
    local injectorPlugin = {}

    function injectorPlugin:beforeSystemStart(core)
        for _, system in pairs(core._systems) do
            system[key] = value
        end
    end

    return injectorPlugin
end

return createInjectorPlugin