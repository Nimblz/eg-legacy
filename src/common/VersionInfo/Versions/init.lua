local versions = {}

for _,module in pairs(script:GetChildren()) do
    if module:IsA("ModuleScript") then
        local versionInfo = require(module)
        versions[versionInfo.id] = versionInfo
    end
end

return versions