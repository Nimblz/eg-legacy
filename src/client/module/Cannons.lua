local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local GrowTweenInfo = TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local WobbleTweenInfo = TweenInfo.new(0.5,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out)

local FLY_TIME = 2

local Cannons = {}

local shooting = false

local function getCannons()
    return Workspace:WaitForChild("cannons"):GetChildren()
end

local function playerFromPart(part)
    local Char = part.Parent
    return Players:GetPlayerFromCharacter(Char)
end

local function blastTween(part)
    local OriginalSize = part.Mesh.Scale

    TweenService:Create(part.Mesh,GrowTweenInfo,{Scale = OriginalSize*(4/3)}):Play()
    wait(0.5)
    TweenService:Create(part.Mesh,WobbleTweenInfo,{Scale = OriginalSize}):Play()
end

local function cannonShoot(model)

    local cannon = model:WaitForChild("Cannon")
    local highPointPart = model:WaitForChild("High")
    local goalPart = model:WaitForChild("Goal")

    local highPoint = highPointPart.Position
    local goal = goalPart.Position

    local steps = 30

    if not shooting then
        shooting = true

        local character = LocalPlayer.Character

        if character and character.PrimaryPart then
            local rootPart = character.PrimaryPart
            local humanoid = character.Humanoid

            humanoid:ChangeState(Enum.HumanoidStateType.Seated)

            local bodyPosition = Instance.new("BodyPosition",rootPart)
            bodyPosition.Position = cannon.Position
            bodyPosition.MaxForce = Vector3.new(300000,300000,300000)
            bodyPosition.P = 20000
            bodyPosition.D = 800

            blastTween(cannon)

            for i = 0,1,1/steps do
                bodyPosition.Position = cannon.Position:lerp(highPoint,i):lerp(goal,i)

                wait(FLY_TIME/steps)
            end

            bodyPosition:Destroy()
        end

        shooting = false
    end
end

local function createCannon(model)
    local debounce = false

    local cannon = model:WaitForChild("Cannon")
    local highPointPart = model:WaitForChild("High")
    local goalPart = model:WaitForChild("Goal")

    highPointPart.Transparency = 1
    goalPart.Transparency = 1

    cannon.Touched:Connect(function(hit)
        if not debounce then
            debounce = true
            local touchedPlayer = playerFromPart(hit)

            if touchedPlayer == LocalPlayer then
                cannonShoot(model)
                wait(1)
            end
            debounce = false
        end
    end)

    print("Cannon",model,"created.")
end

function Cannons:init()
    local cannonModels = getCannons()

    for _, cannon in pairs(cannonModels) do
        createCannon(cannon)
    end
end

function Cannons:start(client)

end

return Cannons