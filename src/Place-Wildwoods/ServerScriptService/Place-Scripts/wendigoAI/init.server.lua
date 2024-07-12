-- </ Related Scripts>
--[[
ServerScriptService {playerHiding}
]]--

-- </ Services>
local RS = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
-- </ Modules>
local wendigoAttacks = require(script.wendigoAttacks) -- We require the wendigo attacks module
local generalFunction = require(RS:WaitForChild("General-Scripts"):FindFirstChild("generalFunctions"))
-- </ Variables>


local Wendigo = RS:WaitForChild("Non-Scripts"):FindFirstChild("Models"):FindFirstChild("Wendigo"):Clone()

-- local Wendigo = game.Workspace:WaitForChild("Rig")
local Humanoid = Wendigo:FindFirstChild("Humanoid")
local HRP = Wendigo:FindFirstChild("HumanoidRootPart")
Wendigo.Parent = game.Workspace

local AudioFolder = RS:WaitForChild("Non-Scripts"):FindFirstChild("Audios")
 
local walkAnim = Instance.new("Animation")
walkAnim.AnimationId = "rbxassetid://18354354981" -- Creates a animation instance for the walk animation
local runAnim = Instance.new("Animation")
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


local RANGE = 100 -- Set the Distance of the creature finding area

local playingHidingPlayer = false

local dafaultWaypoints = {}
local lastWp
local prevWp = {}


local forbidden = RS:WaitForChild("Forbidden")
local ai = require(forbidden:WaitForChild("AI"))
-- </ Functions>
-- Walk System


-- local function hidingPlayer(target)
--     if not playingHidingPlayer then
--         playingHidingPlayer = true
--         local wendigoSniff1 = AudioFolder:WaitForChild("creatureSnif_1"):Clone() 
--         wendigoSniff1.Parent = Wendigo.Head
--         wendigoSniff1:Play()
    
--         wait(2.5)
--         wendigoSniff1:Destroy()
--         -- rodar uma animacao de cheirar
--         playingHidingPlayer = false
--     end
   
-- end

-- local function attack(target)
--     local distance = (Wendigo.PrimaryPart.Position - target.HumanoidRootPart.Position).magnitude
--     local debounce = false
--     if distance > 6.5 then
--         Humanoid:MoveTo(target.HumanoidRootPart.Position)
--     else
--         if not debounce then
--             debounce = true
--             print(wendigoAttacks)
--             wendigoAttacks[generalFunction.getRamInDict(wendigoAttacks)](target)
--             debounce = false
--         end
--     end
-- end















-- local function findNearestTarget()
--     local origin = Wendigo.Head
--     local nearestPlayer = nil

--     for _, player in pairs(game.Players:GetPlayers()) do
--         local character = player.Character
--         if character and character.PrimaryPart and (character.PrimaryPart.Position - origin.Position).magnitude <= RANGE then
--             local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
--             if humanoidRootPart then
--                 local direction = (humanoidRootPart.Position - origin.Position).Unit * RANGE
--                 local ray = workspace:Raycast(origin.Position, direction, rayParams)

--                 if ray then
--                     if ray.Instance:IsDescendantOf(character) then
--                         nearestPlayer = character
--                         character:SetAttribute("OSWall", false)
--                     else
--                         if not nearestPlayer then
--                             character:SetAttribute("OSWall", true)
--                             nearestPlayer = character
--                         end
--                     end
--                 end
--             end
--         end
--     end

--     return nearestPlayer
-- end

-- local function findPath(destination)
--     local path = PathfindingService:CreatePath(pathParams)

--     local success, error = pcall(function()
--         path:ComputeAsync(Wendigo.HumanoidRootPart.Position, destination.Position)
--     end)

--     if success then
--         return path
--     else
--         return nil
--     end
-- end

-- local wps = {}
-- local function walkTo(destination)
--     local path = findPath(destination)
--     local target = destination.Parent:FindFirstChild("Humanoid") and destination.Parent or nil

--     if path and path.Status == Enum.PathStatus.Success then
--         for _, v in ipairs(wps) do
--             v:Destroy()
--         end
--         wps = {}

--         for _, waypoint in ipairs(path:GetWaypoints()) do
--             -- Criação de partes visuais para debug, pode ser removida em produção
--             local p = Instance.new("Part", workspace)
--             p.Anchored = true
--             p.Shape = Enum.PartType.Ball
--             p.Size = Vector3.new(0.5, 0.5, 0.5)
--             p.Position = waypoint.Position
--             p.Color = Color3.fromRGB(255, 0, 212)
--             p.CanCollide = false
--             p.Material = Enum.Material.Neon
--             table.insert(wps, p)
--         end

--         for i, waypoint in ipairs(path:GetWaypoints()) do
--             if i == 1 then continue end -- Pulamos a primeira waypoint

--             Humanoid:MoveTo(waypoint.Position)
--             Humanoid.MoveToFinished:Wait()
--             if (target and lastPos ~= destination.Position) or (not target and findNearestTarget()) then
--                 break
--             end
--         end
--     end
--     lastWp = nil
--     lastPos = nil
-- end

-- local function patrol()
--     local target = findNearestTarget()
--     local waypoints = workspace.Waypoints:GetChildren()

--     if target then
--         lastWp = nil
--         if not lastPos then
--             lastPos = target.HumanoidRootPart.Position
--             walkTo(target.HumanoidRootPart)
--         end
--     else
--         if not lastWp then
--             lastWp = waypoints[math.random(1, #waypoints)]
--             walkTo(lastWp)
--         end
--     end
-- end

-- while task.wait() do
--     patrol()
-- end











-- local function patrol()
-- 	local waypoints = workspace.Waypoints:GetChildren()
-- 	local randomNum = math.random(1, #waypoints)

--     if not lastWp then
--         lastWp = waypoints[randomNum]
--         MoveTo(waypoints[randomNum])
--     else
--         if (HRP.Position - lastWp.Position).magnitude > 6.5 then
--             MoveTo(lastWp)
--         else
--             lastWp = waypoints[randomNum]
--             MoveTo(waypoints[randomNum])
--         end
--     end
-- end
 
-- while task.wait() do
-- 	patrol()
-- end


local function findNearestTarget()
    local origin = Wendigo.Head
    local nearestPlayer = nil

    for _, player in pairs(game.Players:GetPlayers()) do
        local character = player.Character
        if character then
            local distance = (character.PrimaryPart.Position - origin.Position).magnitude
            if distance <= RANGE then
                local direction = (character.HumanoidRootPart.Position - origin.Position).Unit * RANGE
                local ray = workspace:Raycast(origin.Position, direction, rayParams)

                if ray and ray.Instance:IsDescendantOf(character) then
                    nearestPlayer = character
                    character:SetAttribute("OSWall", false)
                else
                    if not nearestPlayer then
                        character:SetAttribute("OSWall", true)
                        nearestPlayer = character
                    end
                end
            end
        end
    end

    return nearestPlayer
end

local function findPath(destination)

    local path = PathfindingService:CreatePath(pathParams)

    local success, _ = pcall(function()
        -- path:ComputeAsync(Wendigo.HumanoidRootPart.Position, destination.Position)
        path:ComputeAsync(Wendigo.RightFoot.Position, destination.Position)
        -- path:ComputeAsync(Wendigo.PrimaryPart.Position - Vector3.new(0, Wendigo.PrimaryPart.Size.Y/0.75, 0), destination)
    end)

    if success then
        print("A")
        return path
    else
        print("B")
    end
end

local waypointsFolder = Instance.new("Folder", Wendigo)
waypointsFolder.Name = "Waypoints"

local function walkTo(destination)
    local path = findPath(destination)
    local target = destination.Parent:FindFirstChild("Humanoid")

    if path and path.Status == Enum.PathStatus.Success then
        waypointsFolder:ClearAllChildren()

        for _, waypoint in ipairs(path:GetWaypoints()) do
            local p = Instance.new("Part", waypointsFolder)
            p.Anchored = true
            p.Shape = Enum.PartType.Ball
            p.Size = Vector3.new(1, 1, 1)
            p.Position = waypoint.Position
            p.Color = Color3.new(0.384314, 0.341176, 1)
            p.CanCollide = false
            p.Material = Enum.Material.Neon
        end


        for i, waypoint in ipairs(path:GetWaypoints()) do
            if i == 1 then
                continue 
            end

            Humanoid:MoveTo(waypoint.Position)
            print(waypoint.Action)
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end

            if (target and lastPos ~= destination.Position) or (not target and findNearestTarget()) then
                lastWp = nil
                lastPos = nil
                return
            end
            Humanoid.MoveToFinished:Wait(1)
        end
    end
    lastWp = nil
    lastPos = nil
end

local function patrol()
    local target = findNearestTarget()
    local waypoints = workspace.Waypoints:GetChildren()


    if target then
        lastPos = target.HumanoidRootPart.Position
        walkTo(target.HumanoidRootPart)
    else
        lastWp = waypoints[math.random(1, #waypoints)]
        walkTo(lastWp)
    end
end

while task.wait() do
    patrol()
end


-- while task.wait() do
--     local target = findNearestTarget()
--     local waypoints = workspace.Waypoints:GetChildren()
--     if target then
--         ai.SmartPathfind(Wendigo,target,true,{Visualize = true, Tracking = true})
--     else
--         ai.SmartPathfind(Wendigo,waypoints[math.random(1,#waypoints)],true,{Visualize = true, Tracking = false})
--     end
-- end