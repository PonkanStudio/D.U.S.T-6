-- </ Services >
local Players = game:GetService("Players")

-- </ Variables >


Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        Character:SetAttribute("OSWall", false)
        Character:SetAttribute("isHiding", false)
    end)
end)