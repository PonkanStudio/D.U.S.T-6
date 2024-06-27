--  </ Services >
local RS = game:GetService("ReplicatedStorage") -- Get the ReplicatedStorage

--  </ Variables >
local Events = RS:WaitForChild("Non-Scripts"):FindFirstChild("Events") -- Get the Events
local ChangeMovementEvent = Events:WaitForChild("ChangeMovement") -- Get the ChangeMovement Event

ChangeMovementEvent.onServerEvent:Connect(function(Player, Movement) -- Listen for the ChangeMovement Event
    if Movement == "Run" then -- Check if the movement was Run
        Player.Character:SetAttribute("decreasingRate_Hunger",1) -- Sets the hunger decreasing rate to 1, increasing the player hunger fastly
        Player.Character:SetAttribute("decreasingRate_Thirst",.5) -- Sets the thirst decreasing rate to .5, increasing the player thirst fastly
    elseif Movement == "Crouch" then -- Check if the movement was Crouch
        Player.Character:SetAttribute("decreasingRate_Hunger",3) -- Sets the hunger decreasing rate to 3, slower than default
        Player.Character:SetAttribute("decreasingRate_Thirst",2) -- Sets the thirst decreasing rate to 2, slower than default
    elseif Movement == "Crawl" then -- Check if the movement was Crawl
        Player.Character:SetAttribute("decreasingRate_Hunger",4) -- Sets the hunger decreasing rate to 4, slower than default
        Player.Character:SetAttribute("decreasingRate_Thirst",3) -- Sets the thirst decreasing rate to 3, slower than default
    else -- Check if it stopped any custom movement
        Player.Character:SetAttribute("decreasingRate_Hunger",2) -- Sets the hunger decreasing rate to 2, default rate
        Player.Character:SetAttribute("decreasingRate_Thirst",1) -- Sets the thirst decreasing rate to 1, default rate
    end
end)