--  </ Services >
local RS = game:GetService("ReplicatedStorage") -- Storage acessível pelo player e servidor
local SP = game:GetService("StarterPlayer") -- Starter Players Service
local Players = game:GetService("Players") -- Get all Players
local UIS = game:GetService("UserInputService") -- Get the User Input Service that allow us to check the player inputs
--  </ Variables >
local Player = Players.LocalPlayer -- Get the Player
local Character = Player.Character or Player.CharacterAdded:Wait() -- Get the Player character or wait for it to be loaded
local Humanoid = Character:WaitForChild("Humanoid") -- Wait for the Humanoid to be added in character

local lastTick = tick()


-- </ System >

    -- Run System
local function startRunning()
    Humanoid.WalkSpeed = 50 -- Sets the Cahracter walkspeed to 50 
end

local function stopRunning()
    Humanoid.WalkSpeed = SP.CharacterWalkSpeed -- Sets the Character walkspeed to the game default walking speed
end

UIS.InputBegan:Connect(function(input,GPE) -- Get all inputs 
    if GPE then return end -- Return if is on Game Processed Event, it means they're typing

    if input.KeyCode == Enum.KeyCode.W then --  Checking if the pressed key was W
        if tick() - lastTick <= 0.5 then -- Checking if the interval of time between this click of W and the last one was less than 0.5 seconds
            startRunning() -- Calls the function to start running
        end

        lastTick = tick() -- Reseting the last tick
    end
end)


UIS.InputEnded:Connect(function(input,GPE)
    if input.KeyCode == Enum.KeyCode.W then
        stopRunning() -- Calls the fuction to stop running
    end
end)