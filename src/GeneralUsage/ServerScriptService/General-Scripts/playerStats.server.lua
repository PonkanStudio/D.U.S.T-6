local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        Character:SetAttribute("decreasingRate_Hunger", 1)
        Character:SetAttribute("decreasingRate_Thirst", 1)
    end)
end)
