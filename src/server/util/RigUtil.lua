local HIP_HEIGHT = 2.7
local WALK_SPEED = 16

local RigUtil = {}

local scalables = {
    Attachment = {
        scaledProps = {
            Position = "Vector3",
        },
    },
    BasePart = {
        scaledProps = {
            Size = "Vector3",
        },
    },
    SpecialMesh = {
        scaledProps = {
            Scale = "Vector3",
        },
    },
    Humanoid = {
        scaledProps = {
            WalkSpeed = "Number",
            HipHeight = "Number",
        },
        scaleFunc = (function(obj,prop,orig,newScale)
            if prop == "WalkSpeed" then
                return orig*(newScale*0.2)
            end
            return orig*newScale
        end),
    }
}

local function newValue(type,value,name)
    local valueobj = Instance.new(type.."Value")
    valueobj.Name = name or "Original_"..type
    valueobj.Value = value
    return valueobj
end

local function forEachScalable(rig, func)
    for _,obj in pairs(rig:GetDescendants()) do
        for type,typeStruct in pairs(scalables) do
            if obj:IsA(type) then
                for propName,valueType in pairs(typeStruct.scaledProps) do
                    func(obj,propName,valueType,typeStruct)
                end
            end
        end
    end
end

function RigUtil.configureRig(rig)

    -- create original property tags
    forEachScalable(rig, function(obj,propName,valueType)
        local origValue = newValue(valueType,obj[propName],"Original_"..propName)

        origValue.Parent = obj
    end)

    -- build the rig
    local humanoid = rig:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:BuildRigFromAttachments()
    end
end

function RigUtil.rescaleRig(rig,newScale)
    for _,obj in pairs(rig:GetDescendants()) do
        -- destroy motors
        if obj:IsA("Motor6D") then
            obj:Destroy()
        end
    end

    -- set based on original props and scale
    forEachScalable(rig, function(obj,propName,valueType,typeStruct)
        local origValue = obj:FindFirstChild("Original_"..propName)

        if origValue then
            -- if there's a special reducer use it
            if typeStruct.scaleFunc then
                obj[propName] = typeStruct.scaleFunc(obj,propName,origValue.Value,newScale)
            else
                obj[propName] = origValue.Value * newScale
            end
        end
    end)

    local humanoid = rig:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:BuildRigFromAttachments()
    end
end

return RigUtil