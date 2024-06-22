--  </ Services >
local RS = game:GetService("ReplicatedStorage") -- Storage acessível pelo player e servidor
local Players = game:GetService("Players") -- Get all Players

-- </ Variables >
local defaultWalkAnim = "rbxassetid://18153744862" -- Defines the default Walk Animation


Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)

        Character.Animate.walk.WalkAnim.AnimationId = defaultWalkAnim -- Changes the default walk animation
		Character.Animate.run.RunAnim.AnimationId = defaultWalkAnim -- Changes the default walk animation
    end)
end)