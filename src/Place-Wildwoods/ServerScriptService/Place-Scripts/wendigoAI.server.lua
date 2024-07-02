-- </ Services>
local RS = game:GetService("ReplicatedStorage")

-- </ Variables>
-- local Wendigo = RS:WaitForChild("Non-Scripts"):FindFirstChild("Models"):FindFirstChild("Wendigo"):Clone()
local Wendigo = game.Workspace:FindFirstChild("Rig")
local Humanoid = Wendigo:FindFirstChild("Humanoid")
Wendigo.Parent = game.Workspace

local pathWaypoints = game.Workspace:WaitForChild("wendigoWaypoints")

-- </ Functions>
-- Walk System


local waypoints = {}
for _, waypoint in ipairs(pathWaypoints:GetChildren()) do
    table.insert(waypoints, waypoint.Position)
end

local lastWp = waypoints[math.random(1, #waypoints)] -- Initialize the last waypoint

local prevWp = {}

while true do
    Humanoid:MoveTo(lastWp)
    wait(.05)
    if (Wendigo.PrimaryPart.Position - lastWp).magnitude <= 3 then
        local closestWp = nil

        for _, wp in ipairs(waypoints) do

            if not table.find(prevWp, wp) then 
                if closestWp == nil then
                    closestWp = wp
                else
                    if (Wendigo.PrimaryPart.Position - wp).magnitude < (Wendigo.PrimaryPart.Position - closestWp).magnitude then
                        closestWp = wp
                    end
                end
            end
        end
        
        table.insert(prevWp, lastWp)
        if #prevWp > #waypoints - 3 then
            table.remove(prevWp, 1)
        end
        lastWp = closestWp
    end
end
