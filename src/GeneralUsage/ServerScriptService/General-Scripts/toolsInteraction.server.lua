local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
    local RS = game:GetService("ReplicatedStorage") -- Storage acessível pelo player e servidor
    local toolInteraction = RS:WaitForChild("AppleEKeyPress", 2)
        
        local GUI = Player.PlayerGui:WaitForChild("StatsBar") -- Get the bars GUI
        local TS = game:GetService("TweenService") -- Get TweenService

        -- Get Each Bar
        local HealthBar = GUI.Health_Stroke.Bar 
        local HungerBar = GUI.Hunger_Stroke.Bar
        local ThirstBar = GUI.Thirst_Stroke.Bar

        local CTS = TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) -- Create an tween info
        local CTS2 = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut) -- Create an tween info


        local lastTimeHunger = tick() -- Initialize the last time player was hungry
        local lastTimeThirst = tick() -- Initialize the last time player was thirsty

        local waitTimeHunger = math.random(3, 7) -- Initialize the wait time for the player to be hungry
        local waitTimeThirst = math.random(3, 6) -- Initialize the wait time for the player to be thirsty

        local actualHunger = 100 -- Hunger Control Variable
        local actualThirst = 100 -- Thirst Control Variable

        local function changeBarSize(bar,barSize) -- Function to smoothly change the bar size. Size must be a number between 0 and 1
            TS:Create(bar, CTS, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on actual bar
            TS:Create(bar.Parent.TransitionBar, CTS2, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on transition bar to get some smoothness
        end

        local function onAppleEKeyPress(player)
            print("pressionou E")
            if actualHunger ~= 100 then
                actualHunger = math.min(actualHunger + 15, 100)
                changeBarSize(HungerBar, actualHunger/100)
                waitTimeHunger = math.random(3, 7) -- Reset the hunger waiting time
                lastTimeHunger = tick() -- Reset the hunger last time
            end
        end

        toolInteraction.OnServerEvent:Connect(onAppleEKeyPress)
    end)