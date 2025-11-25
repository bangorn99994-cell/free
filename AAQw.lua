-- Roblox Script with Beautiful GUI for Delta Executor
-- This script includes a GUI panel with three functions: Lock Head, Invisible, and Adjustable Speed
-- Designed to be injected via Delta Executor or similar tools

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables for functions
local lockedTarget = nil
local lockDistance = 50
local isInvisible = false
local speedMultiplier = 1 -- Default speed multiplier

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Panel Frame (Beautiful design with gradient and rounded corners)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add rounded corners and gradient
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
gradient.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Delta Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.Parent = mainFrame

-- Lock Head Button
local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(0.8, 0, 0, 40)
lockButton.Position = UDim2.new(0.1, 0, 0, 50)
lockButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
lockButton.Text = "Lock Head: OFF"
lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockButton.Font = Enum.Font.SourceSans
lockButton.TextSize = 18
lockButton.Parent = mainFrame

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 5)
lockCorner.Parent = lockButton

-- Invisible Button
local invisibleButton = Instance.new("TextButton")
invisibleButton.Size = UDim2.new(0.8, 0, 0, 40)
invisibleButton.Position = UDim2.new(0.1, 0, 0, 100)
invisibleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
invisibleButton.Text = "Invisible: OFF"
invisibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibleButton.Font = Enum.Font.SourceSans
invisibleButton.TextSize = 18
invisibleButton.Parent = mainFrame

local invisibleCorner = Instance.new("UICorner")
invisibleCorner.CornerRadius = UDim.new(0, 5)
invisibleCorner.Parent = invisibleButton

-- Speed Slider Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedLabel.Position = UDim2.new(0.1, 0, 0, 150)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed Multiplier: 1x"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16
speedLabel.Parent = mainFrame

-- Speed Slider
local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.8, 0, 0, 10)
speedSlider.Position = UDim2.new(0.1, 0, 0, 180)
speedSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedSlider.Parent = mainFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.5, 0, 1, 0) -- Starts at 50%
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
sliderBar.Parent = speedSlider

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = speedSlider

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 5)
barCorner.Parent = sliderBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Functions
local function getClosestPlayer()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local root = character.HumanoidRootPart
    local closest = nil
    local closestDist = lockDistance
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = plr.Character
            end
        end
    end
    return closest
end

-- Lock Head Function
lockButton.MouseButton1Click:Connect(function()
    if lockedTarget then
        lockedTarget = nil
        lockButton.Text = "Lock Head: OFF"
        lockButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    else
        lockedTarget = getClosestPlayer()
        if lockedTarget then
            lockButton.Text = "Lock Head: ON"
            lockButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
end)

-- Invisible Function
invisibleButton.MouseButton1Click:Connect(function()
    if isInvisible then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        isInvisible = false
        invisibleButton.Text = "Invisible: OFF"
        invisibleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    else
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        isInvisible = true
        invisibleButton.Text = "Invisible: ON"
        invisibleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

-- Speed Adjustment (Slider)
local dragging = false
speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UIS:GetMouseLocation()
        local sliderPos = speedSlider.AbsolutePosition
        local sliderSize = speedSlider.AbsoluteSize
        local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        sliderBar.Size = UDim2.new(percent, 0, 1, 0)
        speedMultiplier = 1 + (percent * 4) -- 1x to 5x speed
        speedLabel.Text = string.format("Speed Multiplier: %.1fx", speedMultiplier)
        humanoid.WalkSpeed = 16 * speedMultiplier
    end
    
    -- Lock Head Logic
    if lockedTarget and lockedTarget:FindFirstChild("Head") then
        camera.CFrame = CFrame.new(camera.CFrame.Position, lockedTarget.Head.Position)
    end
end)

-- Close GUI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Make GUI Draggable
local draggingGUI = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingGUI = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if draggingGUI and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingGUI = false
    end
end)
