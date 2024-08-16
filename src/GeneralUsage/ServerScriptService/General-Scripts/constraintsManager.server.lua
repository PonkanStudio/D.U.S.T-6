local Players = game:GetService("Players")

local RS = game:GetService("ReplicatedStorage")
local Events = RS:WaitForChild("Non-Scripts"):WaitForChild("Events")
local flashlightToggleEvent = Events:WaitForChild("FlashlightToggleEvent")


Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        local M6D = Instance.new("Motor6D")
        M6D.Parent = Character.RightHand
        M6D.Name = "RightHandToolGrip"
        Character.ChildAdded:Connect(function(Child)
            if Child:IsA("Tool") and Child:FindFirstChild("BodyAttach") then
                M6D.Part0 = Character.RightHand
                M6D.Part1 = Child:FindFirstChild("BodyAttach")

           
            end
            
        end)

        Character.ChildRemoved:Connect(function(Child)
            if Child:IsA("Tool") and M6D.Part1 == Child.BodyAttach then
               M6D.Part1 = nil
 
            end
        end)
    end)
end)