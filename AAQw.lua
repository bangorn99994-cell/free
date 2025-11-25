--// Head Lock Button Script (Safe for your own game)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- CONFIG
local targetName = "Dummy"   -- Change to the name of NPC you want to lock onto
local headLockEnabled = false

-- Create Button UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.05, 0, 0.8, 0)
Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.TextScaled = true
Button.Text = "Head Lock OFF"
Button.Parent = ScreenGui

-- Function to find head of target
local function getTargetHead()
    local target = workspace:FindFirstChild(targetName)
    if target and target:FindFirstChild("Head") then
        return target.Head
    end
    return nil
end

-- Toggle button
Button.MouseButton1Click:Connect(function()
    headLockEnabled = not headLockEnabled
    Button.Text = headLockEnabled and "Head Lock ON" or "Head Lock OFF"
end)

-- Update camera
RunService.RenderStepped:Connect(function()
    if headLockEnabled then
        local head = getTargetHead()
        if head then
            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
        end
    end
end)
