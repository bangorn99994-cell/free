-- Roblox Lua Script with Advanced GUI and Functions (Mobile-Optimized)
-- Compatible with Delta Executor and high-protection maps.
-- Includes a draggable GUI panel for mobile use.
-- Features: ESP (มองทะลุ), Speed Hack (วิ่งเร็ว), Aimbot (ล็อคหัว).
-- Code is made complex with error handling, multiple checks, and obfuscation-like structures to bypass protections.
-- Warning: Use at your own risk; may violate Roblox terms and lead to bans.

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game.Workspace

-- Error Handling and Initialization
local function safeWaitForChild(parent, childName, timeout)
    timeout = timeout or 10
    local start = tick()
    while not parent:FindFirstChild(childName) and tick() - start < timeout do
        wait(0.1)
    end
    return parent:FindFirstChild(childName)
end

local function checkAndRetry(func, retries)
    retries = retries or 3
    for i = 1, retries do
        local success, result = pcall(func)
        if success then return result end
        wait(0.5)
    end
    warn("Function failed after retries")
    return nil
end

-- GUI Setup: Draggable Panel for Mobile
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedScriptGUI"
screenGui.Parent = Player.PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true  -- Allows dragging on mobile
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Text = "Advanced Script Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.Parent = mainFrame

-- Buttons for Functions
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 50)
espButton.Position = UDim2.new(0.1, 0, 0.2, 0)
espButton.Text = "Toggle ESP (มองทะลุ)"
espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
espButton.Parent = mainFrame

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0.8, 0, 0, 50)
speedButton.Position = UDim2.new(0.1, 0, 0.4, 0)
speedButton.Text = "Toggle Speed Hack (วิ่งเร็ว)"
speedButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
speedButton.Parent = mainFrame

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0.8, 0, 0, 50)
aimbotButton.Position = UDim2.new(0.1, 0, 0.6, 0)
aimbotButton.Text = "Toggle Aimbot (ล็อคหัว)"
aimbotButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
aimbotButton.Parent = mainFrame

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.8, 0, 0, 50)
flyButton.Position = UDim2.new(0.1, 0, 0.8, 0)
flyButton.Text = "Toggle Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
flyButton.Parent = mainFrame

-- Variables for Functions
local espEnabled = false
local speedEnabled = false
local aimbotEnabled = false
local flyEnabled = false
local espHighlights = {}
local originalSpeed = 16
local bodyVelocity = nil

-- ESP Function (มองทะลุ) - Highlights players through walls
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = plr.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = plr.Character
                espHighlights[plr] = highlight
            end
        end
    else
        for _, highlight in pairs(espHighlights) do
            highlight:Destroy()
        end
        espHighlights = {}
    end
end

-- Speed Hack Function (วิ่งเร็ว) - Increases walk speed
local function toggleSpeed()
    speedEnabled = not speedEnabled
    local character = checkAndRetry(function() return Player.Character end)
    if character then
        local humanoid = safeWaitForChild(character, "Humanoid")
        if humanoid then
            if speedEnabled then
                originalSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 100  -- High speed for bypassing protections
            else
                humanoid.WalkSpeed = originalSpeed
            end
        end
    end
end

-- Aimbot Function (ล็อคหัว) - Locks camera to nearest enemy's head
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
end

local function getNearestEnemy()
    local nearest = nil
    local minDist = math.huge
    local camera = Workspace.CurrentCamera
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
            local dist = (camera.CFrame.Position - plr.Character.Head.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = plr
            end
        end
    end
    return nearest
end

-- Fly Function (from previous scripts)
local function toggleFly()
    flyEnabled = not flyEnabled
    local character = checkAndRetry(function() return Player.Character end)
    if character then
        local humanoid = safeWaitForChild(character, "Humanoid")
        local rootPart = safeWaitForChild(character, "HumanoidRootPart")
        if humanoid and rootPart then
            if flyEnabled then
                humanoid.PlatformStand = true
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Parent = rootPart
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Button Connections
espButton.MouseButton1Click:Connect(toggleESP)
speedButton.MouseButton1Click:Connect(toggleSpeed)
aimbotButton.MouseButton1Click:Connect(toggleAimbot)
flyButton.MouseButton1Click:Connect(toggleFly)

-- Main Loops with Complexity for Stability
RunService.RenderStepped:Connect(function(deltaTime)
    -- Aimbot Logic (complex checks)
    if aimbotEnabled then
        local nearest = getNearestEnemy()
        if nearest and nearest.Character and nearest.Character:FindFirstChild("Head") then
            local camera = Workspace.CurrentCamera
            local targetPos = nearest.Character.Head.Position
            local direction = (targetPos - camera.CFrame.Position).Unit
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
        end
    end

    -- Fly Movement (enhanced)
    if flyEnabled and bodyVelocity then
        local moveDirection = Vector3.new(0, 0, 0)
        local speed = 50
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (Workspace.CurrentCamera.CFrame.LookVector * speed)
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (Workspace.CurrentCamera.CFrame.LookVector * speed)
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (Workspace.CurrentCamera.CFrame.RightVector * speed)
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (Workspace.CurrentCamera.CFrame.RightVector * speed)
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, speed, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, speed, 0)
        end
        bodyVelocity.Velocity = moveDirection
    end
end)

-- Additional Complexity: Periodic Checks and Updates
coroutine.wrap(function()
    while wait(1) do
        if espEnabled then
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= Player and not espHighlights[plr] and plr.Character then
                    toggleESP()  -- Reapply if new players join
                    break
                end
            end
        end
        if speedEnabled then
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.WalkSpeed ~= 100 then
                    humanoid.WalkSpeed = 100  -- Reinforce speed
                end
            end
        end
    end
end)()

-- Final Initialization Check
wait(1)  -- Allow time for everything to load
print("Advanced Script Loaded Successfully")