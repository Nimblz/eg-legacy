local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local common = ReplicatedStorage:WaitForChild("common")
local util = common:WaitForChild("util")
local lib = ReplicatedStorage:WaitForChild("lib")
local lightingAreas = ReplicatedStorage:WaitForChild("lightingareas")

local pointIsInPart = require(util:WaitForChild("pointIsInPart"))

local AreaLighting = {}

local currentArea = nil
local transitioningFrom = nil

local INSTANT = 1
local SMOOTH = 2

local areas = {
    cave = {
        lightingProps = {
            Ambient = Color3.fromRGB(44, 48, 59),
            Brightness = 0.1,
            GlobalShadows = false,
            ShadowSoftness = 1,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ExposureCompensation = 0,
            FogColor = Color3.fromRGB(0,0,0),
            FogEnd = 512,
            FogStart = 0,
        },
        transitionToTypes = {
            default = SMOOTH,
        }
    },
    ocean = {
        lightingProps = {
            Ambient = Color3.fromRGB(89, 87, 143),
            Brightness = 1,
            GlobalShadows = true,
            ShadowSoftness = 1,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ExposureCompensation = 0,
            FogColor = Color3.fromRGB(1, 32, 91),
            FogEnd = 1000,
            FogStart = 0,
        },
        transitionToTypes = {
            default = INSTANT,
            abyss = SMOOTH,
            deepabyss = SMOOTH,
        }
    },
    abyss = {
        lightingProps = {
            Ambient = Color3.fromRGB(101, 77, 143),
            Brightness = 0.5,
            GlobalShadows = false,
            ShadowSoftness = 1,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ExposureCompensation = 0,
            FogColor = Color3.fromRGB(58, 37, 88),
            FogEnd = 1000,
            FogStart = 0,
        },
        transitionToTypes = {
            default = INSTANT,
            ocean = SMOOTH,
            deepabyss = SMOOTH,
        }
    },
    deepabyss = {
        lightingProps = {
            Ambient = Color3.fromRGB(128, 103, 112),
            Brightness = 0.07,
            GlobalShadows = false,
            ShadowSoftness = 1,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ExposureCompensation = 0,
            FogColor = Color3.fromRGB(39, 26, 36),
            FogEnd = 600,
            FogStart = 0,
        },
        transitionToTypes = {
            default = INSTANT,
            ocean = SMOOTH,
            abyss = SMOOTH,
        }
    },
    pyramid = {

    },

    default = {
        lightingProps = {
            Ambient = Color3.fromRGB(126, 126, 143),
            Brightness = 2,
            GlobalShadows = true,
            ShadowSoftness = 1,
            OutdoorAmbient = Color3.fromRGB(0,0,0),
            ExposureCompensation = 0,
            FogColor = Color3.fromRGB(127, 127, 127),
            FogEnd = 1000000,
            FogStart = 0,
        },
        transitionToTypes = {
            cave = SMOOTH,
            ocean = INSTANT,
            abyss = INSTANT,
            deepabyss = INSTANT,
        }
    }
}

local targetLightingProps = {

}

local function lerp(x,y,a)
    return x + ((y-x)*a)
end

local function color3lerp(x,y,a)
    return Color3.new(
        lerp(x.R,y.R,a),
        lerp(x.G,y.G,a),
        lerp(x.B,y.B,a)
    )
end

local function changeArea(newAreaName)
    assert(areas[newAreaName], ("Invalid area %s"):format(tostring(newAreaName)))

    if currentArea ~= newAreaName then
        local newAreaLighting = areas[newAreaName]
        transitioningFrom = areas[currentArea]
        for prop,value in pairs(newAreaLighting.lightingProps) do
            targetLightingProps[prop] = value
        end
        currentArea = newAreaName
    end
end

local function updateLighting()
    local camera = Workspace.CurrentCamera
    local camPos = camera.CFrame.p

    -- check against lighting areas
    local newArea = "default"

    for _,areaBounds in pairs(lightingAreas:GetDescendants()) do
        if areaBounds:IsA("BasePart") then
            if pointIsInPart(camPos,areaBounds) then
                newArea = areaBounds.Name
            end
        end
    end

    changeArea(newArea)

    -- transition lighting

    for prop, val in pairs(targetLightingProps) do
        if transitioningFrom and transitioningFrom.transitionToTypes then
            if transitioningFrom.transitionToTypes[currentArea] == SMOOTH then
                if typeof(val) == "Color3" then
                    Lighting[prop] = color3lerp(Lighting[prop],val,0.05)
                elseif typeof(val) == "number" then
                    Lighting[prop] = lerp(Lighting[prop],val,0.05)
                else
                    Lighting[prop] = val
                end
            else
                Lighting[prop] = val
            end
        else
            Lighting[prop] = val
        end
    end
end

function AreaLighting:init()
    
end

function AreaLighting:start(loader)
    print("arealighting startt")

    changeArea("default")
    RunService.RenderStepped:Connect(function()
        updateLighting()
    end)
end

return AreaLighting