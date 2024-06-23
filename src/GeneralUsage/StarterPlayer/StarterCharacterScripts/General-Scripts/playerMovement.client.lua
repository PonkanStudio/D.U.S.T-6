--  </ Services >
local RS = game:GetService("ReplicatedStorage") -- Storage acessível pelo player e servidor
local RunService = game:GetService("RunService")
local SP = game:GetService("StarterPlayer") -- Starter Players Service
local Players = game:GetService("Players") -- Get all Players
local UIS = game:GetService("UserInputService") -- Get the User Input Service that allow us to check the player inputs
--  </ Variables >
local Player = Players.LocalPlayer -- Get the Player
local Character = Player.Character or Player.CharacterAdded:Wait() -- Get the Player character or wait for it to be loaded
local Humanoid = Character:WaitForChild("Humanoid") -- Wait for the Humanoid to be added in character
local Animator = Humanoid:WaitForChild("Animator")


local lastTick = tick()

local runSpeed = 24 -- Default Runspeed
local crouchSpeed = 5 -- Default Crouchspeed
local crawlSpeed = 2 -- Default Crawlspeed


local isRunning = false -- Control variable to check if player is Running
local isCrouching = false -- Control variable to check if player is Crouching
local isCrawling = false -- Control variable to check if player is Crawling


local runAnimation = Instance.new("Animation")
runAnimation.Name = "RunAnimation"
runAnimation.AnimationId = "rbxassetid://18166081332"

local crouchAnimation = Instance.new("Animation")
crouchAnimation.Name = "CrouchAnimation"
crouchAnimation.AnimationId = "rbxassetid://18164372115"

local crouchIdleAnimation = Instance.new("Animation")
crouchIdleAnimation.Name = "CrouchIdleAnimation"
crouchIdleAnimation.AnimationId = "rbxassetid://18166003513"

local crawlAnimation = Instance.new("Animation")
crawlAnimation.Name = "CrawlAnimation"
crawlAnimation.AnimationId = "rbxassetid://18180235884"

local crawlIdleAnimation = Instance.new("Animation")
crawlIdleAnimation.Name = "CrawlIdleAnimation"
crawlIdleAnimation.AnimationId = "rbxassetid://18180502954"


-- </ System >

-- Movement System

local function stopCustomMovement() -- A function to stop all the custom movements
    Humanoid.WalkSpeed = SP.CharacterWalkSpeed -- Sets the character walkspeed to the game default

    isRunning = false -- Resets Control Variable
    isCrouching = false -- Resets Control Variable
    isCrawling = false -- Resets Control Variable

    for k,anims in pairs(Animator:GetPlayingAnimationTracks()) do -- Iterate through all the current playing animations
        if anims.Name:match("Crawl") or anims.Name:match("Crouch") or anims.Name:match("RunAnimation") then -- Check if the animation name contains Crawl, Crouch or Run in it's name
            anims:Stop() -- Stop the animaiton
        end
    end
end
    -- Run System
local function startRunning() 
    stopCustomMovement() -- Stop all custom movement player was doing
    wait(.1) -- Wait some time for stopCustomMovement to finish
    Humanoid.WalkSpeed = runSpeed  -- Sets the Character walkspeed to 50 
    isRunning =  true -- Sets the Control variable to true after reseting it in stopCustomMovement function

    local runAnimTrack = Animator:LoadAnimation(runAnimation) -- Loads the Run Animation
    runAnimTrack:Play() -- Plays the Run Animation
end

    -- Crouch System
local function startCrouching()
    stopCustomMovement() -- Stop all custom movement player was doing
    wait(.1) -- Wait some time for stopCustomMovement to finish
    Humanoid.WalkSpeed = crouchSpeed -- Sets the Character walkspeed to defined crouch speed
    isCrouching =  true -- Sets the Control variable to true after reseting it in stopCustomMovement function

    local crouchAnimTrack = Animator:LoadAnimation(crouchAnimation) -- Loads the Crouch Animation
    crouchAnimTrack:Play() -- Plays the Crouch Animation

    local crouchIdleAnimTrack = Animator:LoadAnimation(crouchIdleAnimation) -- Loads the Idle Crouch Animation

    local idlePlaying = false
    local connection -- We create a connection to control the Heartbeat

    connection = RunService.Heartbeat:Connect(function()
        if Humanoid.MoveDirection.Magnitude == 0 and isCrouching then -- Check if the player is not moving
            if not idlePlaying then -- Check if the Idle Animation is not playing
                idlePlaying = true -- Sets the Control variable to true
                crouchAnimTrack:Stop() -- Stops the Crouch Animation
                crouchIdleAnimTrack:Play() -- Plays the Idle Crouch Animation
            end    
        elseif Humanoid.MoveDirection.Magnitude ~= 0 and isCrouching then -- Check if the player is moving
            if idlePlaying then -- Check if the Idle Animation is playing
                idlePlaying = false -- Sets the Control variable to false
                crouchIdleAnimTrack:Stop() -- Stops the Idle Crouch Animation
                crouchAnimTrack:Play() -- Plays the Crouch Animation
            end
        elseif not isCrouching then -- Check if the player is not crouching
            stopCustomMovement() -- Calls the fuction to stop custom movement
            connection:Disconnect() -- Disconnect the Heartbeat
        end
end)

end

     -- Crawl System
local function startCrawling()
    stopCustomMovement() -- Stop all custom movement player was doing
    wait(.1) -- Wait some time for stopCustomMovement to finish
    Humanoid.WalkSpeed = crawlSpeed -- Sets the Character walkspeed to defined crawl speed
    isCrawling =  true -- Sets the Control variable to true after reseting it in stopCustomMovement function


    local crawlAnimTrack = Animator:LoadAnimation(crawlAnimation) -- Loads the Crawl Animation
    crawlAnimTrack:Play() -- Plays the Crawl Animation

    local crawlIdleAnimTrack = Animator:LoadAnimation(crawlIdleAnimation) -- Loads the Idle Crawl Animation

    local idlePlaying = false
    local connection -- We create a connection to control the Heartbeat

    connection = RunService.Heartbeat:Connect(function()
        if Humanoid.MoveDirection.Magnitude == 0 and isCrawling then -- Check if the player is not moving
            if not idlePlaying then -- Check if the Idle Animation is not playing
                idlePlaying = true -- Sets the Control variable to true
                crawlAnimTrack:Stop() -- Stops the Crawl Animation
                crawlIdleAnimTrack:Play() -- Plays the Idle Crawl Animation
            end    
        elseif Humanoid.MoveDirection.Magnitude ~= 0 and isCrawling then -- Check if the player is moving
            if idlePlaying then -- Check if the Idle Animation is playing
                idlePlaying = false -- Sets the Control variable to false
                crawlIdleAnimTrack:Stop() -- Stops the Idle Crawl Animation
                crawlAnimTrack:Play() -- Plays the Crawl Animation
            end
        elseif not isCrawling then -- Check if the player is not crawling
            stopCustomMovement() -- Calls the fuction to stop custom movement
            connection:Disconnect() -- Disconnect the Heartbeat
        end
    end)
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