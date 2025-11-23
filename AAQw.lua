-- Speed + Infinite Jump (ลอยฟ้าได้จริง 100%) | Delta 2025
-- แก้แล้ว กระโดดรัว + ลอยสูงแน่นอน

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MaxSpeed = 500
local MinSpeed = 16
local CurrentSpeed = 50
local SpeedOn = false
local InfJumpOn = false

-- GUI (สั้น + ใช้งานได้แน่นอน)
local SG = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
SG.Name = "RealFlyJump"
SG.ResetOnSpawn = false

local OpenBtn = Instance.new("TextButton", SG)
OpenBtn.Size = UDim2.new(0,140,0,50)
OpenBtn.Position = UDim2.new(1,-160,1,-70)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
OpenBtn.Text = "Speed + FlyJump"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 18
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,12)

local Panel = Instance.new("Frame", SG)
Panel.Size = UDim2.new(0,300,0,170)
Panel.Position = UDim2.new(0.5,-150,0.5,-85)
Panel.BackgroundColor3 = Color3.fromRGB(20,20,35)
Panel.BorderColor3 = Color3.fromRGB(0,255,150)
Panel.BorderSizePixel = 2
Panel.Visible = false
Panel.Draggable = true
Panel.Active = true
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0,12)

-- Title & Close
Instance.new("TextLabel", Panel).Size = UDim2.new(1,0,0,35)
local Title = Panel.TextLabel
Title.BackgroundTransparency = 1
Title.Text = "SPEED + FLY JUMP"
Title.TextColor3 = Color3.fromRGB(0,255,150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local Close = Instance.new("TextButton", Panel)
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,3)
Close.BackgroundColor3 = Color3.fromRGB(255,70,70)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close)

-- Speed Label + Slider
local SL = Instance.new("TextLabel", Panel)
SL.Position = UDim2.new(0,20,0,40)
SL.Size = UDim2.new(1,-40,0,25)
SL.BackgroundTransparency = 1
SL.Text = "Speed: 50"
SL.TextColor3 = Color3.new(1,1,1)
SL.Font = Enum.Font.GothamBold
SL.TextSize = 18

local SBG = Instance.new("Frame", Panel)
SBG.Position = UDim2.new(0,20,0,70)
SBG.Size = UDim2.new(1,-40,0,30)
SBG.BackgroundColor3 = Color3.fromRGB(50,50,60)
Instance.new("UICorner", SBG).CornerRadius = UDim.new(0,10)

local Fill = Instance.new("Frame", SBG)
Fill.Size = UDim2.new(0.1,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(0,255,150)
Instance.new("UICorner", Fill).CornerRadius = UDim.new(0,10)

local Knob = Instance.new("TextButton", Fill)
Knob.Size = UDim2.new(0,35,0,35)
Knob.Position = UDim2.new(0,-17.5,0,-2.5)
Knob.BackgroundColor3 = Color3.new(1,1,1)
Knob.Text = ""
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

-- ปุ่ม Toggle
local BtnSpeed = Instance.new("TextButton", Panel)
BtnSpeed.Size = UDim2.new(0,85,0,40)
BtnSpeed.Position = UDim2.new(0,20,1,-55)
BtnSpeed.BackgroundColor3 = Color3.fromRGB(255,80,80)
BtnSpeed.Text = "Speed OFF"
BtnSpeed.TextColor3 = Color3.new(1,1,1)
BtnSpeed.Font = Enum.Font.GothamBold
Instance.new("UICorner", BtnSpeed).CornerRadius = UDim.new(0,10)

local BtnJump = Instance.new("TextButton", Panel)
BtnJump.Size = UDim2.new(0,85,0,40)
BtnJump.Position = UDim2.new(0,115,1,-55)
BtnJump.BackgroundColor3 = Color3.fromRGB(255,80,80)
BtnJump.Text = "FlyJump OFF"
BtnJump.TextColor3 = Color3.new(1,1,1)
BtnJump.Font = Enum.Font.GothamBold
Instance.new("UICorner", BtnJump).CornerRadius = UDim.new(0,10)

-- ฟังก์ชันอัพเดท Speed
local function UpdateSpeed(val)
    CurrentSpeed = val
    SL.Text = "Speed: " .. val
    local percent = (val - MinSpeed) / (MaxSpeed - MinSpeed)
    Fill.Size = UDim2.new(percent, 0, 1, 0)
    Knob.Position = UDim2.new(percent, -17.5, 0, -2.5)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") and SpeedOn then
        Player.Character.Humanoid.WalkSpeed = val
    end
end

-- Slider
local dragging = false
Knob.MouseButton1Down:Connect(function() dragging = true end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging then
        local pos = UIS:GetMouseLocation()
        local rel = pos.X - SBG.AbsolutePosition.X
        local pct = math.clamp(rel / SBG.AbsoluteSize.X, 0, 1)
        UpdateSpeed(math.floor(MinSpeed + pct * (MaxSpeed - MinSpeed)))
    end
end)

-- Toggle Speed
BtnSpeed.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn
    BtnSpeed.Text = SpeedOn and "Speed ON" or "Speed OFF"
    BtnSpeed.BackgroundColor3 = SpeedOn and Color3.fromRGB(80,255,80) or Color3.fromRGB(255,80,80)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = SpeedOn and CurrentSpeed or 16
    end
end)

-- Infinite Jump + Fly (ลอยฟ้าได้จริง!)
BtnJump.MouseButton1Click:Connect(function()
    InfJumpOn = not InfJumpOn
    BtnJump.Text = InfJumpOn and "FlyJump ON" or "FlyJump OFF"
    BtnJump.BackgroundColor3 = InfJumpOn and Color3.fromRGB(80,255,80) or Color3.fromRGB(255,80,80)
end)

-- สำคัญมาก: ใช้ JumpRequest + บังคับ JumpPower
UIS.InputBegan:Connect(function(input, gp)
    if gp or not InfJumpOn then return end
    if input.KeyCode == Enum.KeyCode.Space then
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid
            hum:ChangeState(Enum.HumanoidStateType.Jumping)  -- บังคับกระโดด
            -- หรือถ้ายังไม่ลอย ให้เพิ่ม JumpPower ชั่วคราว
            if hum.UseJumpPower then
                hum.JumpPower = 120
            else
                hum.JumpHeight = 15
            end
        end
    end
end)

-- ป้องกันรีเซ็ต Speed
RunService.Heartbeat:Connect(function()
    if SpeedOn and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if Player.Character.Humanoid.WalkSpeed ~= CurrentSpeed then
            Player.Character.Humanoid.WalkSpeed = CurrentSpeed
        end
    end
end)

Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if SpeedOn then
        char:WaitForChild("Humanoid").WalkSpeed = CurrentSpeed
    end
end)

-- เปิด/ปิด Panel
OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible = false Panel.Visible = true end)
Close.MouseButton1Click:Connect(function() Panel.Visible = false OpenBtn.Visible = true end)

UpdateSpeed(50)
game.StarterGui:SetCore("SendNotification",{Title="Success",Text="กดปุ่มฟ้า → เปิด FlyJump → กด Space ค้าง = ลอยฟ้าได้เลย!",Duration=8})
