-- Speed + FLY (บินจริง WASD+Space/Shift) | Delta 2025 ใช้งานได้ 100%
-- แก้ใหม่ บินลื่น + Noclip + Undetected

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MaxSpeed = 500; local MinSpeed = 16; local CurrentSpeed = 50
local SpeedOn = false; local FlyOn = false
local FlyConn, NoclipConn

local SG = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
SG.Name = "SpeedFlyGUI"; SG.ResetOnSpawn = false

-- ปุ่มเปิด
local OpenBtn = Instance.new("TextButton", SG)
OpenBtn.Size = UDim2.new(0,150,0,50); OpenBtn.Position = UDim2.new(1,-170,1,-70)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,170,255); OpenBtn.Text = "🚀 Speed+Fly"
OpenBtn.TextColor3 = Color3.new(1,1,1); OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.TextSize = 18
local OpenC = Instance.new("UICorner", OpenBtn); OpenC.CornerRadius = UDim.new(0,12)

-- Panel
local Panel = Instance.new("Frame", SG)
Panel.Size = UDim2.new(0,320,0,180); Panel.Position = UDim2.new(0.5,-160,0.5,-90)
Panel.BackgroundColor3 = Color3.fromRGB(20,20,35); Panel.BorderSizePixel = 2
Panel.BorderColor3 = Color3.fromRGB(0,255,150); Panel.Visible = false; Panel.Draggable = true; Panel.Active = true
local PanelC = Instance.new("UICorner", Panel); PanelC.CornerRadius = UDim.new(0,12)

-- Title
local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1,0,0,40); Title.BackgroundTransparency = 1; Title.Text = "⚡ SPEED + FLY HACK ⚡"
Title.TextColor3 = Color3.fromRGB(0,255,150); Title.Font = Enum.Font.GothamBold; Title.TextSize = 20

-- Close
local Close = Instance.new("TextButton", Panel)
Close.Size = UDim2.new(0,35,0,35); Close.Position = UDim2.new(1,-40,0,2.5)
Close.BackgroundColor3 = Color3.fromRGB(255,80,80); Close.Text = "X"; Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold; Close.TextSize = 20; local CloseC = Instance.new("UICorner", Close)

-- Speed Label + Slider
local SL = Instance.new("TextLabel", Panel)
SL.Size = UDim2.new(1,-40,0,30); SL.Position = UDim2.new(0,20,0,45)
SL.BackgroundTransparency = 1; SL.Text = "ความเร็ว: 50"; SL.TextColor3 = Color3.new(1,1,1)
SL.Font = Enum.Font.GothamBold; SL.TextSize = 18

local SBG = Instance.new("Frame", Panel)
SBG.Size = UDim2.new(1,-40,0,25); SBG.Position = UDim2.new(0,20,0,80)
SBG.BackgroundColor3 = Color3.fromRGB(50,50,60); local SBGC = Instance.new("UICorner", SBG); SBGC.CornerRadius = UDim.new(0,12)

local Fill = Instance.new("Frame", SBG); Fill.Size = UDim2.new(0.068,0,1,0); Fill.BackgroundColor3 = Color3.fromRGB(0,255,150)
local FillC = Instance.new("UICorner", Fill); FillC.CornerRadius = UDim.new(0,12)

local Knob = Instance.new("TextButton", Fill)
Knob.Size = UDim2.new(0,32,0,32); Knob.Position = UDim2.new(0,-16,0,-3.5)
Knob.BackgroundColor3 = Color3.new(1,1,1); Knob.Text = ""; local KnobC = Instance.new("UICorner", Knob); KnobC.CornerRadius = UDim.new(1,0)

-- Toggle Speed
local TSpeed = Instance.new("TextButton", Panel)
TSpeed.Size = UDim2.new(0,90,0,45); TSpeed.Position = UDim2.new(0,20,1,-55)
TSpeed.BackgroundColor3 = Color3.fromRGB(255,80,80); TSpeed.Text = "Speed OFF"
TSpeed.TextColor3 = Color3.new(1,1,1); TSpeed.Font = Enum.Font.GothamBold; TSpeed.TextSize = 16
local TSC = Instance.new("UICorner", TSpeed); TSC.CornerRadius = UDim.new(0,10)

-- Toggle Fly
local TFly = Instance.new("TextButton", Panel)
TFly.Size = UDim2.new(0,90,0,45); TFly.Position = UDim2.new(0,120,1,-55)
TFly.BackgroundColor3 = Color3.fromRGB(255,80,80); TFly.Text = "Fly OFF"
TFly.TextColor3 = Color3.new(1,1,1); TFly.Font = Enum.Font.GothamBold; TFly.TextSize = 16
local TFC = Instance.new("UICorner", TFly); TFC.CornerRadius = UDim.new(0,10)

-- Update Speed Func
local function UpdateSpeed(val)
    CurrentSpeed = val; SL.Text = "ความเร็ว: " .. val
    local p = (val - MinSpeed) / (MaxSpeed - MinSpeed)
    Fill.Size = UDim2.new(p,0,1,0); Knob.Position = UDim2.new(p,-16,0,-3.5)
end

-- Slider Drag
local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
RunService.RenderStepped:Connect(function()
    if dragging then
        local pos = UIS:GetMouseLocation()
        local rel = pos.X - SBG.AbsolutePosition.X
        local pct = math.clamp(rel / SBG.AbsoluteSize.X, 0, 1)
        UpdateSpeed(math.floor(MinSpeed + pct * (MaxSpeed - MinSpeed)))
    end
end)

-- Speed Toggle
TSpeed.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn
    TSpeed.Text = SpeedOn and "Speed ON" or "Speed OFF"
    TSpeed.BackgroundColor3 = SpeedOn and Color3.fromRGB(80,255,80) or Color3.fromRGB(255,80,80)
    local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = SpeedOn and CurrentSpeed or 16 end
end)

-- Fly Funcs
local function StartFly()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    hum.PlatformStand = true
    FlyConn = RunService.Heartbeat:Connect(function()
        if not FlyOn or not char.Parent or not root.Parent then FlyConn:Disconnect(); return end
        local cam = workspace.CurrentCamera
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.yAxis end
        root.Velocity = move.Unit * CurrentSpeed
    end)
    NoclipConn = RunService.Stepped:Connect(function()
        if not FlyOn then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function StopFly()
    FlyOn = false
    if FlyConn then FlyConn:Disconnect(); FlyConn = nil end
    if NoclipConn then NoclipConn:Disconnect(); NoclipConn = nil end
    local char = Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if root then root.Velocity = Vector3.new() end
    end
end

-- Fly Toggle
TFly.MouseButton1Click:Connect(function()
    FlyOn = not FlyOn
    TFly.Text = FlyOn and "Fly ON" or "Fly OFF"
    TFly.BackgroundColor3 = FlyOn and Color3.fromRGB(80,255,80) or Color3.fromRGB(255,80,80)
    if FlyOn then StartFly() else StopFly() end
end)

-- Speed Anti-Reset (only when not flying)
RunService.Heartbeat:Connect(function()
    if SpeedOn and Player.Character and Player.Character:FindFirstChild("Humanoid") and not FlyOn then
        if Player.Character.Humanoid.WalkSpeed ~= CurrentSpeed then
            Player.Character.Humanoid.WalkSpeed = CurrentSpeed
        end
    end
end)

-- Respawn
Player.CharacterAdded:Connect(function()
    task.wait(1)
    local hum = Player.Character:WaitForChild("Humanoid")
    hum.WalkSpeed = SpeedOn and CurrentSpeed or 16
    if FlyOn then StartFly() end
end)

-- Open/Close
OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible = false; Panel.Visible = true end)
Close.MouseButton1Click:Connect(function() Panel.Visible = false; OpenBtn.Visible = true; StopFly() end)

UpdateSpeed(50)
game.StarterGui:SetCore("SendNotification", {
    Title = "🚀 Speed + Fly"; Text = "กดปุ่มฟ้า → Fly ON → WASD+Space/Shift = บินลื่นทะลุกำแพง!"; Duration = 8
})
