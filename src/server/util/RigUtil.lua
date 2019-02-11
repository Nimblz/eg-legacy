
local HIP_HEIGHT = 2.7
local WALK_SPEED = 16

local RigUtil = {}

local function newValue(type,value,name,parent)
    local valueobj = Instance.new(type.."Value")
    valueobj.Name = name or ""
    valueobj.Value = value
    valueobj.Parent = parent
    return valueobj
end

function RigUtil.configureRig(rig)
    for _,obj in pairs(rig:GetDescendants()) do
        if obj:IsA("Attachment") then
            newValue("Vector3",obj.Position,"OriginalPosition",obj)
        end
        if obj:IsA("BasePart") then
            newValue("Vector3",obj.Size,"OriginalSize",obj)
        end
    end

    local humanoid = rig:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:BuildRigFromAttachments()
    end
end

function RigUtil.rescaleRig(rig,newScale)
    for _,obj in pairs(rig:GetDescendants()) do
        if obj:IsA("Attachment") then
            local origPos = obj:FindFirstChild("OriginalPosition").Value

            obj.Position = origPos * newScale
        end
        if obj:IsA("BasePart") then
            local origSize = obj:FindFirstChild("OriginalSize").Value
            obj.Size = origSize * newScale
        end
        if obj:IsA("Humanoid") then
            obj.HipHeight = HIP_HEIGHT * newScale
            obj.WalkSpeed = WALK_SPEED * (1+(math.abs(1-newScale)/6))
        end
        if obj:IsA("Motor6D") then
            obj:Destroy()
        end
    end

    local humanoid = rig:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:BuildRigFromAttachments()
    end
end

return RigUtil