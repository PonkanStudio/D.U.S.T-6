-- </ Services>

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

-- </ Variables>
local Events = RS:WaitForChild("Non-Scripts"):FindFirstChild("Events") -- Get the Events folder
local EatEvent = Events:WaitForChild("EatEvent") -- Get the Eat Event


local ConsumablesFolder = RS:WaitForChild("Non-Scripts"):FindFirstChild("Cosumables") -- Get the Consumables Folder, which contains all the consumables items
local CosumableLocations = game.Workspace:FindFirstChild("Consumables_Location") --  Get the Cosumable Locations to clone the consumables
local onGameConsumables = game.Workspace:FindFirstChild("Consumables_OnGame") -- Folder to contain the consumables


for k, locationPart in pairs(CosumableLocations:GetChildren()) do -- Iterate through all the Cosumable Locations
    local newCosumable = ConsumablesFolder:GetChildren()[math.random(1,#ConsumablesFolder:GetChildren())]:Clone() -- Clone a random consumable item
    local consumableItemScript = RS:WaitForChild("General-Scripts"):FindFirstChild("consumableItem"):Clone()
    consumableItemScript.Parent = newCosumable

    newCosumable.Parent = onGameConsumables -- Set it's parent to be the onGameConsumables folder
    newCosumable:SetPrimaryPartCFrame(locationPart.CFrame) -- Set it's location as the Cosumable Location

    local prompt = newCosumable.Handle:WaitForChild("PromtAttachment").ProximityPrompt -- We get the prompt
    prompt.TriggerEnded:Connect(function(Player) -- When prompt is triggered, we transfer the item to the player's backpack
        newCosumable.Parent = Player.Backpack -- Transfer the item to the player's backpack
        prompt.Enabled = false -- Deactivate the prompt
    end)
end

EatEvent.OnServerEvent:Connect(function(Player, Consumable) -- Listen for the Eat Event
    EatEvent:FireClient(Player, Consumable.Name)
    Consumable:Destroy()
end)