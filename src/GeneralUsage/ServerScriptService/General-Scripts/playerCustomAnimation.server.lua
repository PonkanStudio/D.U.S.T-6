--  </ Services >
local RS = game:GetService("ReplicatedStorage") -- Storage acessível pelo player e servidor
local Players = game:GetService("Players") -- Get all Players
-- </ Variables >
local defaultWalkAnim = "rbxassetid://18153744862"


Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)

        Character.Animate.walk.WalkAnim.AnimationId = defaultWalkAnim
		Character.Animate.run.RunAnim.AnimationId = defaultWalkAnim
    end)
end)