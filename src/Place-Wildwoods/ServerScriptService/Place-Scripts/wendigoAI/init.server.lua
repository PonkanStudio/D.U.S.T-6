-- </ Related Scripts>
--[[
ServerScriptService {playerHiding}
]]--

-- </ Services>
local RS = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
-- </ Variables>
local wendigoAttacks = require(script.wendigoAttacks) -- We require the wendigo attacks module

local Wendigo = RS:WaitForChild("Non-Scripts"):FindFirstChild("Models"):FindFirstChild("Wendigo"):Clone()

-- local Wendigo = game.Workspace:WaitForChild("Rig")
local Humanoid = Wendigo:FindFirstChild("Humanoid")
local HRP = Wendigo:FindFirstChild("HumanoidRootPart")
local hrp = Wendigo:FindFirstChild("HumanoidRootPart")
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

-- </ Functions>
-- Walk System


local function hidingPlayer(target)
    if not playingHidingPlayer then
        playingHidingPlayer = true
        local wendigoSniff1 = AudioFolder:WaitForChild("creatureSnif_1"):Clone() 
        wendigoSniff1.Parent = Wendigo.Head
        wendigoSniff1:Play()
    
        wait(2.5)
        wendigoSniff1:Destroy()
        -- rodar uma animacao de cheirar
        playingHidingPlayer = false
    end
   
end

local function attack(target)
    local distance = (Wendigo.PrimaryPart.Position - target.HumanoidRootPart.Position).magnitude
    local debounce = false
    if distance > 6.5 then
        Humanoid:MoveTo(target.HumanoidRootPart.Position)
    else
        if not debounce then
            debounce = true
            wendigoAttacks[math.random(1, #wendigoAttacks)](target)
            debounce = false
        end
    end
end


local function canSeeTarget(target)
	local orgin = hrp.Position
	local direction = (target.HumanoidRootPart.Position - hrp.Position).Unit * RANGE
	local ray = workspace:Raycast(orgin, direction, rayParams)
 
	if ray and ray.Instance then
		if ray.Instance:IsDescendantOf(target) then
			return true
		else
			return false
		end
	else
		return false
	end
end
 

local function findTarget()
	local players = game.Players:GetPlayers()
	local maxDistance = RANGE
	local nearestTarget
 
	for i, player in pairs(players) do
		if player.Character then
			local target = player.Character
			local distance = (hrp.Position - target.HumanoidRootPart.Position).Magnitude
 
			if distance < maxDistance and canSeeTarget(target) then
				nearestTarget = target
				maxDistance = distance
			end
		end
	end
 
	return nearestTarget
end

local function findNearestTarget()
    local origin = Wendigo.Head

    local nearestPlayer = nil
    for k, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            if (player.Character.PrimaryPart.Position - origin.Position).magnitude <= RANGE then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local direction = (player.Character.HumanoidRootPart.Position - origin.Position).Unit * RANGE
                    local Ray = workspace:Raycast(origin.Position, direction, rayParams)

                    if Ray then
                        if Ray.Instance:IsDescendantOf(player.Character) then
                            nearestPlayer = player.Character
                            player.Character:SetAttribute("OSWall", false)
                        else
                            if not nearestPlayer then
                                player.Character:SetAttribute("OSWall", true)
                                nearestPlayer = player.Character
                            end
                        end
                    end
                end    
            end    
        end
    end

    return nearestPlayer
end

local function findPath(destination)
        local path = PathfindingService:CreatePath(pathParams)

        local Success, erro = pcall(function()
            path:ComputeAsync(Wendigo.HumanoidRootPart.Position, destination.Position)
        end)

        if Success then
            return path
        else
            return nil
        end
end


local function moveTo(destination)
    local path = findPath(destination)

    if path and path.Status == Enum.PathStatus.Success then -- If we found a path to the destination
        for _, waypoint in ipairs(path:GetWaypoints()) do
            path.Blocked:Connect(function() -- If the path is blocked we destroy the path avoiding a infinite loop
                path:Destroy()
            end)

            local target = findTarget()
            if target and target.Humanoid.Health > 0 then -- We found a Player, ALIVE, within the creature range
                if target:GetAttribute("OSWall") then -- We found a Player that is on the otherside of a wall
                    if tick() - lastTimeHiding > 30 then
                        hidingPlayer(target)
                    end
                end

                
                if walkAnimPlaying then
                    walkAnimTrack:Stop()
                    runAnimTrack:Play()
                    Wendigo.Humanoid.WalkSpeed = 32
                    walkAnimPlaying = false
                    runAnimPlaying = true
                end

                lastPos = target.HumanoidRootPart.Position
                attack(target)
            else -- Failed to find a Player within the creature range
                if walkAnimPlaying == false then
                    walkAnimTrack:Play()
                    runAnimTrack:Stop()
                    walkAnimPlaying = true
                    runAnimPlaying = false
                    Wendigo.Humanoid.WalkSpeed = 8
                end

                if waypoint.Action == Enum.PathWaypointAction.Jump then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end

                if lastPos then
                    Humanoid:MoveTo(lastPos)
                    Humanoid.MoveToFinished:Wait()
                    lastPos = nil
                    break
                else
                    Humanoid:MoveTo(waypoint.Position)
                    Humanoid.MoveToFinished:Wait()
                end
            end 
        end
    end
end

-- local function patrol()
    
-- end

-- while task.wait(0.05) do

--     local nearestPlayer = canSeePlayer()

--     moveTo(nearestPlayer)

-- end

 
 
-- local function attack(target)
-- 	local distance = (hrp.Position - target.HumanoidRootPart.Position).Magnitude
-- 	local debounce = false
 
-- 	if distance > 6.5 then
-- 		Humanoid:MoveTo(target.HumanoidRootPart.Position)
-- 	else
-- 		if debounce == false then
-- 			debounce = true
 
-- 			target.Humanoid.Health -= 30
-- 			task.wait(0.5)
-- 			debounce = false
-- 		end
-- 	end
-- end
 
 
local function patrol()
	local waypoints = workspace.Waypoints:GetChildren()
	local randomNum = math.random(1, #waypoints)
	moveTo(waypoints[randomNum])
end
 
while task.wait(0.05) do
	patrol()
end