wait(1)

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Character = Player.Character
local RS = game:GetService("ReplicatedStorage")

local FlashlightOn = false

local FlashlightCamera = Instance.new("Part")
FlashlightCamera.Anchored = true
FlashlightCamera.Parent = Camera
FlashlightCamera.Transparency = 1
FlashlightCamera.Name = "FlashlightCamera"
FlashlightCamera.CanCollide = false


local FlashLIGHT = Instance.new("SpotLight")
FlashLIGHT.Parent = FlashlightCamera
FlashLIGHT.Enabled = false
FlashLIGHT.Range = 20
FlashLIGHT.Brightness = 2

local flashlightToggleEvent = RS:FindFirstChild("FlashlightToggleEvent")
if not flashlightToggleEvent then
    flashlightToggleEvent = Instance.new("BindableEvent")
    flashlightToggleEvent.Name = "FlashlightToggleEvent"
    flashlightToggleEvent.Parent = RS
end


local FlashlightModule = RS:WaitForChild("General-Scripts"):FindFirstChild("FlashlightModule")
if not FlashlightModule then
    warn("FlashlightModule não encontrado em ReplicatedStorage.")
    return
end


local function ToggleFlashlight(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F then
        if FlashlightModule.actualCharge > 0 then
            if not FlashlightOn then
                flashlightToggleEvent:Fire(true)
            else
                flashlightToggleEvent:Fire(false)
            end
        else
            print("Não há energia suficiente para ligar a lanterna.")
        end
    end
end

flashlightToggleEvent.Event:Connect(function(state)
    FlashlightOn = state
    FlashLIGHT.Enabled = state
end)

UserInputService.InputBegan:Connect(ToggleFlashlight)

Player.Character:WaitForChild("Humanoid").Died:Connect(function()
    FlashlightCamera:Destroy()
    FlashLIGHT:Destroy()
end)

RunService.RenderStepped:Connect(function()
    TweenService:Create(FlashlightCamera, TweenInfo.new(0.2), { CFrame = Camera.CFrame }):Play()
end)