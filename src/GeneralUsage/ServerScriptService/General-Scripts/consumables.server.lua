-- </ Services>

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- </ Variables>
local Events = RS:WaitForChild("Non-Scripts"):FindFirstChild("Events") -- Get the Events folder
local cosumableEvent = Events:WaitForChild("cosumableEvent") -- Get the Eat Event
local flashlightToggleEvent = Events:WaitForChild("FlashlightToggleEvent") -- Busccamos pelo Remote Event


local ConsumablesFolder = RS:WaitForChild("Non-Scripts"):FindFirstChild("Cosumables") -- Get the Consumables Folder, which contains all the consumables items
local ConsumableLocations = game.Workspace:FindFirstChild("Consumables_Location") --  Get the Cosumable Locations to clone the consumables
local onGameConsumables = game.Workspace:FindFirstChild("Consumables_OnGame") -- Folder to contain the consumables

local consumablesValues = {
    ["Meds"] = {
        ["Type"] = "Cure",
        ["Recovery"] = "15"
    }
}

------------------------------------------------------------------

for k, locationPart in pairs(ConsumableLocations:GetChildren()) do -- Iterate through all the Cosumable Locations
    local newConsumable = ConsumablesFolder:GetChildren()[math.random(1,#ConsumablesFolder:GetChildren())]:Clone() -- Clone a random consumable item
    local consumableItemScript = RS:WaitForChild("General-Scripts"):FindFirstChild("consumableItem"):Clone()
    consumableItemScript.Parent = newConsumable

    newConsumable.Parent = onGameConsumables -- Set it's parent to be the onGameConsumables folder
    newConsumable:SetPrimaryPartCFrame(locationPart.CFrame) -- Set it's location as the Cosumable Location

    local prompt = newConsumable.Handle:WaitForChild("PromtAttachment").ProximityPrompt -- We get the prompt
    prompt.TriggerEnded:Connect(function(Player) -- When prompt is triggered, we transfer the item to the player's backpack
        newConsumable.Parent = Player.Backpack -- Transfer the item to the player's backpack
        prompt.Enabled = false
    end)

    local function OnAncestryChanged() -- Runs when a change is detected in the object's Parent
        if newConsumable.Parent == Workspace then -- Checks if the object is in the Workspace
            local prompt = newConsumable.Handle:WaitForChild("PromtAttachment").ProximityPrompt -- if it is, gets the prompt
            prompt.Enabled = true -- reactivates the prompt
        end
    end
    newConsumable.AncestryChanged:Connect(OnAncestryChanged)

end


cosumableEvent.OnServerEvent:Connect(function(Player, Consumable) -- Listen for the Eat Event
    if consumablesValues[Consumable.Name] then -- That means the consumable is a "Cure"
        Player.Character:FindFirstChild("Humanoid").Health += consumablesValues[Consumable.Name].Recovery
    else
        cosumableEvent:FireClient(Player, Consumable.Name)
    end
    
    Consumable:Destroy()
end)


flashlightToggleEvent.OnServerEvent:Connect(function(Player, Status)
    flashlightToggleEvent:FireAllClients(Player, Status)
end)