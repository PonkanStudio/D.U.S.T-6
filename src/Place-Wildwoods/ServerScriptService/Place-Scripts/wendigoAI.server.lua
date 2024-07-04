-- </ Services>
local RS = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
-- </ Variables>
-- local Wendigo = RS:WaitForChild("Non-Scripts"):FindFirstChild("Models"):FindFirstChild("Wendigo"):Clone()

local Wendigo = game.Workspace:WaitForChild("Rig")
local Humanoid = Wendigo:FindFirstChild("Humanoid")
local HRP = Wendigo:FindFirstChild("HumanoidRootPart")
Wendigo.Parent = game.Workspace


local walkAnim = Instance.new("Animation")
walkAnim.AnimationId = "rbxassetid://18252546777" -- Creates a animation instance for the walk animation
local runAnim = Instance.new("Animation")
runAnim.AnimationId = "rbxassetid://18308743403" -- Creates a animation instance for the run animation

local walkAnimTrack = Humanoid.Animator:LoadAnimation(walkAnim) -- Load the Walk Animation on creature Animator
local runAnimTrack = Humanoid.Animator:LoadAnimation(runAnim) -- Load the Run Animation on creature Animator

local lastPlayer = nil

local pathWaypoints = game.Workspace:WaitForChild("wendigoWaypoints")

local pathParams = {
    AgentHeight = 12.5,
    AgentRadius = 3.5,
    AgentCanJump = true
} 

local rayParams = RaycastParams.new() -- Create a list of raycast parameters
rayParams.FilterType = Enum.RaycastFilterType.Blacklist -- Set the FilterType to blacklist
rayParams.FilterDescendantsInstances = {Wendigo} -- Set the Wendigo and it's descendants 

local lastPos = nil
local status = nil
local animPlaying = false

local RANGE = 100 -- Set the Distance of the creature finding area

-- </ Functions>
-- Walk System


local waypoints = {}
for _, waypoint in ipairs(pathWaypoints:GetChildren()) do
    table.insert(waypoints, waypoint.Position)
end


local function canSeePlayer()
    local origin = Wendigo.Head

    local nearestPlayer = nil
    for k, player in pairs(game.Players:GetPlayers()) do
        if (player.Character.PrimaryPart.Position - origin.Position).magnitude <= RANGE then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local direction = (player.Character.HumanoidRootPart.Position - origin.Position).Unit * RANGE

                local Ray = workspace:Raycast(origin.Position, direction, rayParams)

                if Ray then
                    if Ray.Instance:IsDescendantOf(player.Character) then
                        nearestPlayer = player
                    else
                        if not nearestPlayer then
                            -- nearestPlayer = "ots-wall_"..player.Name
                            nearestPlayer = player
                        end
                    end
                end
            end    
        end
    end

    return nearestPlayer
end

local function findPath(target)
    if target then -- It means we have a Player to target down
        local path = PathfindingService:CreatePath(pathParams)

        local Success, erro = pcall(function()
            path:ComputeAsync(Wendigo.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
        end)

        if Success then
            return path
        else
            return nil
        end
    end
end

local function moveTo(target)
    local path = findPath(target)

    if path then
        if path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()

            for _, waypoint in ipairs(waypoints) do
                local part = Instance.new("Part", game.Workspace)
                part.Material = Enum.Material.Neon
                part.Size = Vector3.new(.5, .5, .5)
                part.Position = waypoint.Position
                part.CanCollide = false
                if path.Blocked then
                    part.Color = Color3.new(1,0,0)
                else
                    part.Color = Color3.new(0,1,0)
                end
                

                game.Debris:AddItem(part, 1)
            end
        end    
    end
    
end

wait(5)

while true do
    wait(.1)

    local nearestPlayer = canSeePlayer()
    moveTo(nearestPlayer)
end