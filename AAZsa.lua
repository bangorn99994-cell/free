-- Speed Hack + GUI Panel (Delta Executor / Mobile & PC)
-- กด RightShift เพื่อเปิด/ปิดหน้าต่าง

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local MaxSpeed = 500
local MinSpeed = 16
local CurrentSpeed = 50
local SpeedEnabled = false

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHackGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- หน้าต่างหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 180)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- มุมโค้ง
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- เงา (สวยขึ้น)
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- หัวข้อ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ SPEED HACK PANEL"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- ปุ่มปิด
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Text แสดงความเร็วปัจจุบัน
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -40, 0, 30)
SpeedLabel.Position = UDim2.new(0, 20, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "ความเร็ว: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 18
SpeedLabel.Parent = MainFrame

-- Slider Background
local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(1, -40, 0, 20)
SliderBG.Position = UDim2.new(0, 20, 0, 90)
SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SliderBG.BorderSizePixel = 0
SliderBG.Parent = MainFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 10)
SliderCorner.Parent = SliderBG

-- Slider Fill
local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.084, 0, 1, 0) -- เริ่มที่ 50/500
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 10)
FillCorner.Parent = SliderFill

-- ปุ่มลูกกลิ้ง Slider
local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 30, 0, 30)
SliderKnob.Position = UDim2.new(0, -15, 0, -5)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.Text = ""
SliderKnob.Parent = SliderFill

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = SliderKnob

-- ปุ่มเปิด/ปิด Speed
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 120, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -60, 1, -55)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 18
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

-- ฟังก์ชันอัพเดทความเร็ว
local function UpdateSpeed(value)
    CurrentSpeed = value
    SpeedLabel.Text = "ความเร็ว: " .. value
    local percent = (value - MinSpeed) / (MaxSpeed - MinSpeed)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderKnob.Position = UDim2.new(percent, -15, 0, -5)
    
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = SpeedEnabled and value or 16
    end
end

-- Slider Logic
local dragging = false
SliderKnob.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mouse = Player:GetMouse()
        local relativeX = mouse.X - SliderBG.AbsolutePosition.X
        local percent = math.clamp(relativeX / SliderBG.AbsoluteSize.X, 0, 1)
        local newSpeed = math.floor(MinSpeed + (MaxSpeed - MinSpeed) * percent)
        newSpeed = math.clamp(newSpeed, MinSpeed, MaxSpeed)
        UpdateSpeed(newSpeed)
    end
end)

-- ปุ่ม Toggle
ToggleBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    if SpeedEnabled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        ToggleBtn.Text = "ON"
        game.StarterGui:SetCore("SendNotification", {Title="Speed Hack", Text="เปิดแล้ว! ความเร็ว: "..CurrentSpeed, Duration=2})
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ToggleBtn.Text = "OFF"
    end
    UpdateSpeed(CurrentSpeed)
end)

-- รีสปอนด์
Player.CharacterAdded:Connect(function(char)
    wait(1)
    if SpeedEnabled then
        char:WaitForChild("Humanoid").WalkSpeed = CurrentSpeed
    end
end)

-- ป้องกันรีเซ็ต
RunService.Heartbeat:Connect(function()
    if SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if Player.Character.Humanoid.WalkSpeed ~= CurrentSpeed then
            Player.Character.Humanoid.WalkSpeed = CurrentSpeed
        end
    end
end)

-- เปิด/ปิด GUI ด้วย RightShift
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            -- เอฟเฟกต์เปิด
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0,320,0,180)}):Play()
        end
    end
end)

-- เริ่มต้น
UpdateSpeed(50)
game.StarterGui:SetCore("SendNotification", {
    Title = "Speed Hack GUI";
    Text = "กด RightShift เพื่อเปิดหน้าต่าง";
    Duration = 5;
})