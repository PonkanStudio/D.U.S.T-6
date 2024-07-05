-- </ Services >
local UIS = game:GetService("UserInputService") -- Get the UserInputService
local RS = game:GetService("ReplicatedStorage") -- Get the ReplicatedStorage
local Players = game:GetService("Players") -- Get all Players

-- </ Variables >
local Tool = script.Parent -- Get the tool
local Player = Players.LocalPlayer -- Get the local Player
local Character = Player.Character or Player.CharacterAdded:Wait() -- Get the player character
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")
local Events = RS:WaitForChild("Non-Scripts"):WaitForChild("Events") -- Get the Events Folder
local EatEvent = Events:WaitForChild("cosumableEvent")
local Animation = Tool:FindFirstChild("usageAnimation") -- Get the consumable animation

local ToolEquiped = false

local eatAnimTrack = Animator:LoadAnimation(Animation) -- Loads the Animation
Tool.Activated:Connect(function() -- Checks when the tool is activated

  eatAnimTrack:Play()
  eatAnimTrack.Stopped:Wait()
  if ToolEquiped then
   EatEvent:FireServer(Tool)
  end
end)


Tool.Equipped:Connect(function() -- Checks when the tool is equipped
   ToolEquiped = true
end)

Tool.Unequipped:Connect(function() -- Checks when the tool is unequipped
   ToolEquiped = false
  eatAnimTrack:Stop()
end)


