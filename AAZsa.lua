-- Speed Hack + GUI แก้ไขแล้ว แสดงแน่นอน 100% (Delta Executor)
-- แก้ปัญหา GUI ไม่โผล่ / มองไม่เห็นgg

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local MaxSpeed = 500
local MinSpeed = 16
local CurrentSpeed = 50
local SpeedEnabled = false

-- สร้าง ScreenGui วางใน PlayerGui แทน CoreGui (บาง Executor บัง CoreGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHackGUI_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")  -- เปลี่ยนตรงนี้สำคัญมาก!

-- ปุ่มเปิด GUI (โผล่ชัดเจนมุมขวาล่าง)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 150, 0, 50)
OpenButton.Position = UDim2.new(1, -170, 1, -70)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenButton.Text = "เปิด Speed Panel"
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 18
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton

-- หน้าต่างหลัก (ซ่อนไว้ก่อน)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 200)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 200)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

-- หัวข้อ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "⚡ SPEED HACK ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

-- ปุ่มปิดหน้าต่าง
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame
local CloseCorner = Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

-- แถบแสดงความเร็ว
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -40, 0, 35)
SpeedLabel.Position = UDim2.new(0, 20, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "ความเร็ว: 50"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 20
SpeedLabel.Parent = MainFrame

-- Slider
local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(1, -40, 0, 30)
SliderBG.Position = UDim2.new(0, 20, 0, 100)
SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SliderBG.Parent = MainFrame
local BGC = Instance.new("UICorner")
BGC.CornerRadius = UDim.new(0, 15)
BGC.Parent = SliderBG

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.1, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
SliderFill.Parent = SliderBG
local FillC = Instance.new("UICorner")
FillC.CornerRadius = UDim.new(0, 15)
FillC.Parent = SliderFill

local Knob = Instance.new("TextButton")
Knob.Size = UDim2.new(0, 40, 0, 40)
Knob.Position = UDim2.new(0, -5, 0, -5)
Knob.BackgroundColor3 = Color3.new(1,1,1)
Knob.Text = ""
Knob.Parent = SliderFill
local KnobC = Instance.new("UICorner")
KnobC.CornerRadius = UDim.new(1, 0)
KnobC.Parent = Knob

-- ปุ่ม ON/OFF
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 140, 0, 50)
Toggle.Position = UDim2.new(0.5, -70, 1, -65)
Toggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Toggle.Text = "OFF"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 24
Toggle.Parent = MainFrame
local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(0, 12)
TC.Parent = Toggle

-- ฟังก์ชันอัพเดทความเร็ว
local function setSpeed(val)
    CurrentSpeed = val
    SpeedLabel.Text = "ความเร็ว: " .. val
    local percent = (val - MinSpeed) / (MaxSpeed - MinSpeed)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    Knob.Position = UDim2.new(percent, -5, 0, -5)
    
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = SpeedEnabled and val or 16
    end
end

-- Slider ลากได้
local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UIS:GetMouseLocation()
        local relX = mousePos.X - SliderBG.AbsolutePosition.X
        local percent = math.clamp(relX / SliderBG.AbsoluteSize.X, 0, 1)
        local newVal = math.floor(MinSpeed + percent * (MaxSpeed - MinSpeed))
        setSpeed(newVal)
    end
end)

-- ปุ่ม Toggle
Toggle.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    if SpeedEnabled then
        Toggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        Toggle.Text = "ON"
    else
        Toggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        Toggle.Text = "OFF"
    end
    setSpeed(CurrentSpeed)
end)

-- ปุ่มเปิดหน้าต่าง
OpenButton.MouseButton1Click:Connect(function()
    OpenButton.Visible = false
    MainFrame.Visible = true
end)

-- รีสปอนด์ + ป้องกันรีเซ็ต
Player.CharacterAdded:Connect(function(c)
    task.wait(1)
    if SpeedEnabled and c:FindFirstChild("Humanoid") then
        c.Humanoid.WalkSpeed = CurrentSpeed
    end
end)

RunService.Heartbeat:Connect(function()
    if SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if Player.Character.Humanoid.WalkSpeed ~= CurrentSpeed then
            Player.Character.Humanoid.WalkSpeed = CurrentSpeed
        end
    end
end)

-- แจ้งเตือนตอนโหลดเสร็จ
game.StarterGui:SetCore("SendNotification", {
    Title = "Speed Hack";
    Text = "กดปุ่มสีฟ้ามุมขวาล่างเพื่อเปิดเมนู!";
    Duration = 8;
})

setSpeed(50)
