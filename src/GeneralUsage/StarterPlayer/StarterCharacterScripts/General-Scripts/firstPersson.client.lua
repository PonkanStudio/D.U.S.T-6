--  </ Services >
local RS = game:GetService("ReplicatedStorage") -- Storage acessível pelo player e servidor
local RunService = game:GetService("RunService")
local SP = game:GetService("StarterPlayer") -- Starter Players Service
local Players = game:GetService("Players") -- Get all Players
local UIS = game:GetService("UserInputService") -- Get the User Input Service that allow us to check the player inputs
--  </ Variables >
local Player = Players.LocalPlayer -- Get the Player
local Character = Player.Character or Player.CharacterAdded:Wait() -- Get the Player character or wait for it to be loaded
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid.CameraOffset = Vector3.new(0,0.5,-1)

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Icon = "http://www.roblox.com/asset?id=0000000"



RunService.RenderStepped:Connect(function()
    for _,v in pairs(Character:GetChildren()) do
        if (v:IsA("BasePart") or v:IsA("MeshPart")) and v.Name ~= "HumanoidRootPart" and v.Name ~= "Head" then
            v.LocalTransparencyModifier = 0
            v.Transparency = 0
        end
    end
    
end)

