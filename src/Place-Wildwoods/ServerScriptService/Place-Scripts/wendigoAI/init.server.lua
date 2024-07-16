-- </ Related Scripts>
--[[
ServerScriptService {playerHiding}
]]--

-- </ Services>
local RS = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local StarterPack = game:GetService("StarterPack")
-- </ Modules>
local wendigoAttacks = require(script.wendigoAttacks) -- We require the wendigo attacks module
local generalFunction = require(RS:WaitForChild("General-Scripts"):FindFirstChild("generalFunctions"))
-- </ Variables>
local Events = RS:WaitForChild("Non-Scripts"):FindFirstChild("Events")

local Wendigo = RS:WaitForChild("Non-Scripts"):FindFirstChild("Models"):FindFirstChild("Wendigo"):Clone()

-- local Wendigo = game.Workspace:WaitForChild("Rig")
local Humanoid = Wendigo:FindFirstChild("Humanoid")
local HRP = Wendigo:FindFirstChild("HumanoidRootPart")
Wendigo.Parent = game.Workspace

local AudioFolder = RS:WaitForChild("Non-Scripts"):FindFirstChild("Audios")
 
local walkAnim = Instance.new("Animation")
walkAnim.Name = "walkAnimation"
walkAnim.AnimationId = "rbxassetid://18473130950" -- Creates a animation instance for the walk animation

local runAnim = Instance.new("Animation")
runAnim.Name = "runAnimation"
runAnim.AnimationId = "rbxassetid://18354460118" -- Creates a animation instance for the run animation

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
local walkAnimPlaying = false
local runAnimPlaying = false
local lastTimeHiding = tick()


local RANGE = 50 -- Set the Distance of the creature finding area

local playingHidingPlayer = false

local dafaultWaypoints = {}
local lastWp
local prevWp = {}


local forbidden = RS:WaitForChild("Forbidden")
local ai = require(forbidden:WaitForChild("AI"))
-- </ Functions>
-- Walk System


local function findNearestTarget()
    local origin = Wendigo.Head
    local nearestPlayer = nil

    local success, erro = pcall(function()
        for _, player in pairs(game.Players:GetPlayers()) do
            local character = player.Character
            if character then
                local distance = (character.PrimaryPart.Position - origin.Position).magnitude
                if distance <= RANGE then
                    local direction = (character.HumanoidRootPart.Position - origin.Position).Unit * RANGE
                    local ray = workspace:Raycast(origin.Position, direction, rayParams)
    
                    if ray and ray.Instance:IsDescendantOf(character) then
                        if nearestPlayer and distance < (nearestPlayer.PrimaryPart.Position - origin.Position).magnitude then
                            nearestPlayer = character
                        elseif not nearestPlayer then
                            nearestPlayer = character
                        end
                        character:SetAttribute("OSWall", false)
                    else
                        if (not nearestPlayer) or (nearestPlayer and distance < (nearestPlayer.PrimaryPart.Position - origin.Position).magnitude and nearestPlayer:GetAttribute("OSWall")) then
                            character:SetAttribute("OSWall", true)
                            nearestPlayer = character
                        end
                    end
                end
            end
        end
    end)
    

    return nearestPlayer
end

local lastTarget = nil
while task.wait() do
    local target = findNearestTarget()
    local waypoints = workspace.Waypoints:GetChildren()
    if target then
        if lastTarget ~= target or lastTarget == nil then
            lastTarget = target
        end
        spawn(function()
            local newTarget = findNearestTarget()
            while newTarget == target do
                wait(.05)
                newTarget = findNearestTarget()
            end
            ai.Stop(Wendigo)
        end)
        ai.SmartPathfind(Wendigo,target,true,{Visualize = true, Tracking = true})
    else
        spawn(function()
            local newTarget = findNearestTarget()
            while newTarget == nil do
                wait(.05)
                newTarget = findNearestTarget()
            end
            ai.Stop(Wendigo)
        end)
        ai.SmartPathfind(Wendigo,waypoints[math.random(1,#waypoints)],true,{Visualize = true, Tracking = false})
    end
end
