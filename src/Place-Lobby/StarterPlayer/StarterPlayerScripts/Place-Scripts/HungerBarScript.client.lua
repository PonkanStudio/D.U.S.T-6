local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character.Humanoid:WaitForChild("Humanoid")
local GUI = Player.PlayerGui:WaitForChild("StatsBar")

local HungerBar = GUI.Hunger_Stroke.Bar
local ThirstBar = GUI.Thirst_Stroke.Bar
local HealthBar = GUI.Health_Stroke.Bar

HealthBar = Humanoid