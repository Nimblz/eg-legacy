local SoundService = game:GetService("SoundService")

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

-- creates and plays the sound for you, keep in mind that the sound is destroyed when it finishes playing.
function Sound:playSound(id,volume,pitch,source,group)
    local sound = self:newSound(id,volume,pitch,source,group)

    sound.Ended:Connect(function() sound:Destroy() end)

    sound:Play()

    return sound
end

function Sound:init()
    Sound.effectsGroup = Instance.new("SoundGroup")
    Sound.musicGroup = Instance.new("EffectsGroup")

    Sound.effectsGroup.Parent = SoundService
    Sound.musicGroup.Parent = SoundService
end

return Sound