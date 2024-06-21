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

local runSpeed = 24
local crouchSpeed = 6
local crawlSpeed = 3


local isRunning = false -- Control variable to check if player is Running
local isCrouching = false -- Control variable to check if player is Crouching
local isCrawling = false -- Control variable to check if player is Crawling
-- </ System >

-- Movement System

local function stopCustomMovement() -- A function to stop all the custom movements
    Humanoid.WalkSpeed = SP.CharacterWalkSpeed -- Sets the character walkspeed to the game default

    isRunning = false
    isCrouching = false
    isCrawling = false
end
    -- Run System
local function startRunning() 
    stopCustomMovement() -- Stop all custom movement player was doing
    Humanoid.WalkSpeed = runSpeed  -- Sets the Character walkspeed to 50 
    isRunning =  true -- Sets the Control variable to true after reseting it in stopCustomMovement function
end

    -- Crouch System
local function startCrouching()
    stopCustomMovement() -- Stop all custom movement player was doing
    Humanoid.WalkSpeed = crouchSpeed -- Sets the Character walkspeed to defined crouch speed
    isCrouching =  true -- Sets the Control variable to true after reseting it in stopCustomMovement function
end

     -- Crawl System

local function startCrawling()
    stopCustomMovement() -- Stop all custom movement player was doing
    Humanoid.WalkSpeed = crawlSpeed -- Sets the Character walkspeed to defined crawl speed
    isCrawling =  true -- Sets the Control variable to true after reseting it in stopCustomMovement function
end

UIS.InputBegan:Connect(function(input,GPE) -- Get all inputs 
    if GPE then return end -- Return if is on Game Processed Event, it means they're typing

    if input.KeyCode == Enum.KeyCode.W then --  Checking if the pressed key was W to start running
        if tick() - lastTick <= 0.5 then -- Checking if the interval of time between this click of W and the last one was less than 0.5 seconds
            startRunning() -- Calls the function to start running
        end

    lastTick = tick() -- Reseting the last tick
    elseif input.KeyCode == Enum.KeyCode.C then --  Checking if the pressed key was C to start crouching
        if isCrouching then
            stopCustomMovement() -- Calls the fuction to stop custom movement
            isCrouching = false
        else
            startCrouching() -- Calls the function to start crouching
        end
    elseif input.KeyCode == Enum.KeyCode.Z then --  Checking if the pressed key was Z to start crawling
        if isCrawling then
            stopCustomMovement() -- Calls the fuction to stop custom movement
            isCrawling = false
        else
            startCrawling() -- Calls the function to start crawling   
        end
    end
end)


UIS.InputEnded:Connect(function(input,GPE)
    if input.KeyCode == Enum.KeyCode.W and isRunning and not isCrouching and not isCrawling then
        stopCustomMovement() -- Calls the fuction to stop custom movement
        isRunning = false
    end
end)