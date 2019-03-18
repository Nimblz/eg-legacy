local VersionInfo = {}

local Versions = require(script:WaitForChild("Versions"))

function VersionInfo:getVersions()
    return Versions
end

function VersionInfo:getVersion(id)
    return Versions[id]
end

function VersionInfo:getCurrent()
    return Versions[#Versions]
end

return VersionInfo