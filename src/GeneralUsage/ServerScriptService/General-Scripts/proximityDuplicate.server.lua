local RS = game:GetService("ReplicatedStorage")
local Events = RS:WaitForChild("Non-Scripts"):WaitForChild("Events")

local proximityDuplicate = Events:WaitForChild("proximityDuplicate")

proximityDuplicate.OnServerEvent:Connect(function(Player, Tool)
    if Tool then
        Tool.BodyAttach.PromtAttachment.ProximityPrompt.Enabled = false
        Player.Character:FindFirstChild("Humanoid"):EquipTool(Tool)
    end
end)

game.Workspace.ChildAdded:Connect(function(Child)
    if Child:IsA("Tool") then
        if Child:FindFirstChild("BodyAttach") then
            if Child.BodyAttach:FindFirstChild("PromtAttachment") then
                Child.BodyAttach.PromtAttachment.ProximityPrompt.Enabled = true
            end
        end
    end
end)