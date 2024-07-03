-- </ Services>
local RS = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
-- </ Variables>
local Wendigo = RS:WaitForChild("Non-Scripts"):FindFirstChild("Models"):FindFirstChild("Wendigo"):Clone()
local Humanoid = Wendigo:FindFirstChild("Humanoid")
local HRP = Wendigo:FindFirstChild("HumanoidRootPart")
Wendigo.Parent = game.Workspace

local walkAnim = Humanoid.Animator:LoadAnimation("rbxassetid://18252546777") -- Load the Walk Animation on creature Animator
local runAnim = Humanoid.Animator:LoadAnimation("rbxassetid://18308743403") -- Load the Run Animation on creature Animator

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

local RANGE = 100 -- Set the Range of the creature finding

-- </ Functions>
-- Walk System


local waypoints = {}
for _, waypoint in ipairs(pathWaypoints:GetChildren()) do
    table.insert(waypoints, waypoint.Position)
end


local function canSeeTarget()
    local origin = Wendigo.Head
end