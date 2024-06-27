local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local GUI = Player.PlayerGui:WaitForChild("HungerBar")

while wait(0.1) do
    if script.Parent.Size.X.Scale <= 0 then
        script.Parent.Parent.Parent.Parent.Character.Humanoid.Health -= 1
        script.Parent.Size = UDim2.new(0.201, 0, 0.052, 0)
    else
        script.Parent.Size = UDim2.new(0.002, 0, 0, 0)
    end
end