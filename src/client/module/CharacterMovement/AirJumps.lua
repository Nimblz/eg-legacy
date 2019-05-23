-- character movement modules, recieves character on respawn, recieves updates when stats change
local UserInputService = game:GetService("UserInputService")

local AirJumps = {}

local sound

local character
local humanoid
local canAirJump = false
local airJumps = 99
local jumpsUsed = 0
local oldPower
local TIME_BETWEEN_JUMPS = 0.3
local DOUBLE_JUMP_POWER_MULTIPLIER = 1.3

local function onJumpRequest()
    if not character or not humanoid or not character:IsDescendantOf(workspace) or
        humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return
    end

    if canAirJump and airJumps > jumpsUsed then
        jumpsUsed = jumpsUsed + 1
        humanoid.JumpPower = oldPower * DOUBLE_JUMP_POWER_MULTIPLIER
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        canAirJump = false

        -- TODO: Spawn effect here
        -- TODO: play double jump sound effect
        sound:playSound(2428506580)
    end
end

function AirJumps:characterSpawned(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    canAirJump = false
    jumpsUsed = 0
    oldPower = humanoid.JumpPower

    humanoid.StateChanged:connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            canAirJump = false
            jumpsUsed = 0
            humanoid.JumpPower = oldPower
        elseif new == Enum.HumanoidStateType.Freefall then
            wait(TIME_BETWEEN_JUMPS)
            canAirJump = true
        end
    end)
end

function AirJumps:statsUpdate(newStats)
    airJumps = newStats.jumps
end

function AirJumps:init(client)
    sound = client:getModule("Sound")
    UserInputService.JumpRequest:connect(onJumpRequest)
end

return AirJumps