-- character movement modules, recieves character on respawn, recieves updates when stats change
local ContextActionService = game:GetService("ContextActionService")

local Dashes = {}

local sound

local character
local humanoid
local dashes = 2
local dashesUsed = 0
local canDash = true
local TIME_BETWEEN_DASHES = 0.5
local DASH_RECHARGE_TIME = 2
local DASH_POWER = 64 -- studs per sec in dash direction
--local DASH_LENGTH = 0.4 -- how long to sustain
--local CANCEL_VERTICAL_VEL = true -- no fall while dashing

local function onDashRequest()
    if not character or not humanoid or not character:IsDescendantOf(workspace) or
        humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return
    end

    if canDash and dashes > dashesUsed then
        canDash = false

        local root = character.PrimaryPart
        if root then
            dashesUsed = dashesUsed + 1
            local facingVec = (root.CFrame.LookVector * Vector3.new(1,0,1)).unit

            humanoid:ChangeState(Enum.HumanoidStateType.Physics)

            root.Velocity = facingVec*DASH_POWER + Vector3.new(0,DASH_POWER/2,0)

            sound:playSound(2428506580)
            spawn(function()
                wait(DASH_RECHARGE_TIME)
                dashesUsed = math.max(dashesUsed - 1, 0)
            end)
        end
        wait(TIME_BETWEEN_DASHES)
        humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        canDash = true
    end
end

local function onDashInput(name, inputState, inputObj)
    if inputState == Enum.UserInputState.Begin then
        onDashRequest()
    end
end

function Dashes:characterSpawned(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    oldPower = humanoid.JumpPower
end

function Dashes:statsUpdate(newStats)

end

function Dashes:init(client)
    sound = client:getModule("Sound")

    ContextActionService:bindAction("Dash", onDashInput, true, Enum.KeyCode.F, Enum.KeyCode.ButtonX)
end

return Dashes