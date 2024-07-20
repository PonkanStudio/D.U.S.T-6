local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        Character:SetAttribute("decreasingRate_Hunger", 2) -- Sets the default hunger decreasing rate to 2
        Character:SetAttribute("decreasingRate_Thirst", 1) -- Sets the default thirst decreasing rate to 1
        Character:SetAttribute("decreasingRate_Charge", 20) -- Sets the default charge deacreasing rate to 2
    end)
end)
