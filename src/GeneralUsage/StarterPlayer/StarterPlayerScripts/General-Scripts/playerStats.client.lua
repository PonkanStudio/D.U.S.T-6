-- </ Services>
local Players = game:GetService("Players") -- Get all Players
local TS = game:GetService("TweenService") -- Get TweenService
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
-- </ Variables>
local Player = Players.LocalPlayer -- Get the Player
local Character = Player.Character or Player.CharacterAdded:Wait() -- Get Player Character or wait to be loaded
local Humanoid = Character:WaitForChild("Humanoid") -- Get Player Humanoid
local GUI = Player.PlayerGui:WaitForChild("StatsBar") -- Get the bars GUI

-- Get Each Bar
local HealthBar = GUI.Health_Stroke.Bar 
local HungerBar = GUI.Hunger_Stroke.Bar
local ThirstBar = GUI.Thirst_Stroke.Bar

local CTS = TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) -- Create an tween info
local CTS2 = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut) -- Create an tween info

-- TESTE
local lastTimeHunger = tick() -- Initialize the last time player was hungry
local lastTimeThirst = tick() -- Initialize the last time player was thirsty

local waitTimeHunger = math.random(3, 7) -- Initialize the wait time for the player to be hungry
local waitTimeThirst = math.random(3, 6) -- Initialize the wait time for the player to be thirsty

local hungerDecreasingRate = Character:GetAttribute("decreasingRate_Hunger") -- Get the Hunger decreasing rate as the initial value
local thirstDecreasingRate = Character:GetAttribute("decreasingRate_Thirst")-- Get the Thirst decreasing rate as the initial value

local actualHunger = 100 -- Hunger Control Variable
local actualThirst = 100 -- Thirst Control Variable
local actualHealth = 100 -- Health Control Variable

local cosumableEvent = RS:WaitForChild("Non-Scripts"):WaitForChild("Events"):WaitForChild("cosumableEvent")

local consumablesValues = {
    ["WaterBottle"] = {
        ["Type"] = "Drink",
        ["Recovery"] = 10
    },
    ["Apple"] = {
        ["Type"] = "Eat",
        ["Recovery"] = 20
    },
    ["Meds"] = {
        ["Type"] = "Cure",
        ["Recovery"] = "15"
    }
}

----------------------------------------------------------------------------

local function changeBarSize(bar,barSize) -- Function to smoothly change the bar size. Size must be a number between 0 and 1
    if barSize > bar.Size.X.Scale then
        TS:Create(bar, CTS2, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on transition bar to get some smoothness
        TS:Create(bar.Parent.TransitionBar, CTS, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on actual bar
    else
        TS:Create(bar, CTS, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on actual bar
        TS:Create(bar.Parent.TransitionBar, CTS2, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on transition bar to get some smoothness
    end
   
end

Humanoid.HealthChanged:Connect(function(oldHealth) -- Check when the player's health changed
    changeBarSize(HealthBar, Humanoid.Health / Humanoid.MaxHealth) -- Calls the function to get the bar size, We need to divide the health by the max health to get a number between 0 and 1. Ex Health = 75, max health = 100, 75/100 = 0.75
end)

Character:GetAttributeChangedSignal("decreasingRate_Hunger"):Connect(function() -- Checks when the hunger decreasing rate changed
    hungerDecreasingRate = Character:GetAttribute("decreasingRate_Hunger") -- Sets the local hunger decreasing rate
end)

Character:GetAttributeChangedSignal("decreasingRate_Thirst"):Connect(function() -- Checks when the thirst decreasing rate changed
    thirstDecreasingRate = Character:GetAttribute("decreasingRate_Thirst") -- Sets the local thirst decreasing rate
end)

RunService.Heartbeat:Connect(function() -- Get every Heartbeat time interval
    if (tick() - lastTimeHunger) >= waitTimeHunger * hungerDecreasingRate then -- Check if enough time has passed since the last time the player was hungry
        actualHunger -= 1 -- Decrease the actual hunger
        changeBarSize(HungerBar, actualHunger/100) -- Change the bar size
        waitTimeHunger = math.random(3, 7) -- Reset the hunger waiting time
        lastTimeHunger = tick() -- Reset the hunger last time
    end

    if (tick() - lastTimeThirst) >= waitTimeThirst * thirstDecreasingRate then -- Check if enough time has passed since the last time the player was thirsty
        actualThirst -= 1 -- Decrease the actual thirst
        changeBarSize(ThirstBar, actualThirst/100) -- Change the bar size
        waitTimeThirst = math.random(3, 6) -- Reset the thirst waiting time
        lastTimeThirst = tick() -- Reset the hunger last time
    end
end)


cosumableEvent.OnClientEvent:Connect(function(consumableName) -- Listen for the Eat Event
    local consumable = consumablesValues[consumableName]
    print("Você usou: " .. consumableName) -- Print for tracking

    if consumable.Type == "Eat" then -- Check if the consumables type is 'Eat'
        actualHunger = math.clamp(actualHunger + consumable.Recovery, 0, 100) -- Updates the 'actualHunger' valor
        changeBarSize(HungerBar, actualHunger / 100) -- Modifies the size of the bar related to 'Hunger'
    elseif consumable.Type == "Drink" then -- Check if the consumables type is 'Drink'
        actualThirst = math.clamp(actualThirst + consumable.Recovery, 0, 100) -- Updates the 'actualThirst' valor
        changeBarSize(ThirstBar, actualThirst / 100) -- Modifies the size of the bar related to 'Thirst'
    end
end)