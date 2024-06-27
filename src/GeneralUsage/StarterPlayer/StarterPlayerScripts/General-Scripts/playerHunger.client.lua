
-- </ Services>
local Players = game:GetService("Players") -- Get all Players
local TS = game:GetService("TweenService") -- Get TweenService

-- </ Variables>
local Player = Players.LocalPlayer -- Get the Player
local Character = Player.Character or Player.CharacterAdded:Wait() -- Get Player Character or wait to be loaded
local Humanoid = Character:WaitForChild("Humanoid") -- Get Player Humanoid
local GUI = Player.PlayerGui:WaitForChild("StatsBar") -- Get the bars GUI


-- Get Each Bar
local HealthBar = GUI.Health_Stroke.Bar 
local HungerBar = GUI.Hunger_Stroke.Bar
local ThirstBar = GUI.Thirst_Stroke.Bar


local actualHunger = 100
local actualThirst = 100


local CTS = TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) -- Create an tween info
local CTS2 = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut) -- Create an tween info



local function changeBarSize(bar,barSize) -- Function to smoothly change the bar size. Size must be a number between 0 and 1
    TS:Create(bar, CTS, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on actual bar
    TS:Create(bar.Parent.TransitionBar, CTS2, {Size = UDim2.new(barSize, 0 , 1, 0)}):Play() -- Play the tween on transition bar to get some smoothness
end

Humanoid.HealthChanged:Connect(function(oldHealth) -- Check when the player's health changed
    changeBarSize(HealthBar, Humanoid.Health / Humanoid.MaxHealth) -- Calls the function to get the bar size, We need to divide the health by the max health to get a number between 0 and 1. Ex Health = 75, max health = 100, 75/100 = 0.75
end)