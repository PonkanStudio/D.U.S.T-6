--  </ Services >
local RS = game:GetService("ReplicatedStorage") -- Storage acessível pelo player e servidor
local SP = game:GetService("StarterPlayer") -- Starter Players Service
local Players = game:GetService("Players") -- Get all Players
--  </ Variables >
local Player = Players.LocalPlayer -- Get the Player
local Character = Player.Character or Player.CharacterAdded:Wait() -- Get the Player character or wait for it to be loaded
local Humanoid = Character:WaitForChild("Humanoid") -- Wait for the Humanoid to be added in character

-- </ Attributes >
Players.PlayerAdded:Connect(function(player) 
player:SetAttribute("Life", 10) -- Defining life attribute when the player enters the game
player:SetAttribute("Stamina", 10) -- Defining stamina attribute when the player enters the game
player:SetAttribute("Strength", 10) -- Defining strength attribute when the player enters the game 
player:SetAttribute("Intelligence", 10) -- Defining intelligence attribute when the player enters the game
player:SetAttribute("Speed", 10) -- Defining speed attribute when the player enters the game
end)

--[[CLASSES: 
Doctor; Tank; Map; Leader; Photographer
ATTRIBUTES(1 a 10): 
Life, Stamina, Strength, Intelligence, Speed --]]

-- </ ClassesAttributes >
local Classes = { -- Defining values for the player's attributes within each class
    ["Doctor"] = {
        ["Life"] = 6,
        ["Stamina"] = 8,
        ["Strength"] = 4,
        ["Intelligence"]= 10,
        ["Speed"] = 8
    },
    ["Tank"] = {
        ["Life"] = 10,
        ["Stamina"] = 5,
        ["Strength"] = 10,
        ["Intelligence"]= 5,
        ["Speed"] = 6
    },
    ["Map"] = {
        ["Life"] = 7,
        ["Stamina"] = 7,
        ["Strength"] = 10,
        ["Intelligence"]= 8,
        ["Speed"] = 8
    },
    ["Leader"] = {
        ["Life"] = 7,
        ["Stamina"] = 8,
        ["Strength"] = 8,
        ["Intelligence"]= 8,
        ["Speed"] = 7
    },
    ["Photographer"] = {
        ["Life"] = 7,
        ["Stamina"] = 7,
        ["Strength"] = 4,
        ["Intelligence"]= 4,
        ["Speed"] = 8
} }