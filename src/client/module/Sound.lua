local SoundService = game:GetService("SoundService")

local soundBin -- workspace sound bin

local Sound = {}

Sound.effectsGroup = nil
Sound.musicGroup = nil

function Sound:newSound(id,volume,pitch,source,group)
    id = id or 12222058
    volume = volume or 0.5
    pitch = pitch or 1
    source = source or SoundService
    group = group or Sound.effectsGroup

    local sound = Instance.new("Sound")

    sound.SoundId = "rbxassetid://"..id
    sound.Volume = volume
    sound.Pitch = pitch
    sound.SoundGroup = group

    sound.Parent = source

    return sound
end

function Sound:playSound(id,volume,pitch,source,group)
    local sound = self:newSound(id,volume,pitch,source,group)

    sound.Ended:Connect(function() sound:Destroy() end)

    sound:Play()

    return sound
end

function Sound:playSoundAtCFrame(id,volume,pitch,cframe,group)
    local sourcePart = Instance.new("Part")
    local sound = self:newSound(id,volume,pitch,sourcePart,group)

    sourcePart.CFrame = cframe or CFrame.new()
    sourcePart.Size = Vector3.new(1,1,1)
    sourcePart.Anchored = true
    sourcePart.CanCollide = false
    sourcePart.Material = Enum.Material.Air
    sourcePart.Transparency = 1

    sourcePart.Parent = soundBin

    sound.Ended:Connect(function() sourcePart:Destroy() end)

    sound:Play()

    return sound
end

function Sound:init()
    soundBin = Instance.new("Folder")
    soundBin.Name = "soundbin"
    soundBin.Parent = workspace

    Sound.effectsGroup = Instance.new("SoundGroup")
    Sound.musicGroup = Instance.new("SoundGroup")

    Sound.effectsGroup.Parent = SoundService
    Sound.musicGroup.Parent = SoundService
end

return Sound