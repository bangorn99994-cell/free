--[[ 
    GOD LOCK 1000% (Distance Based)
    - ล็อคคนที่อยู่ใกล้ตัวที่สุด (ไม่ต้องเอาเมาส์ชี้)
    - ล็อคติดหัว 100% กระโดดไม่หลุด
    - ทะลุกำแพง (ถ้าอยู่ใกล้)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ตั้งค่าความโหด
getgenv().GodLock = false 
local Target = nil
local MaxDistance = 500 -- ระยะทำการ (หน่วยเป็น Studs)

-- --- สร้าง GUI (แบบลากได้ + กดติดง่าย) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local RangeLabel = Instance.new("TextLabel")

ScreenGui.Name = "GodLockGUI"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- กรอบหลัก
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1.000
MainFrame.Position = UDim2.new(0.8, -20, 0.35, 0) -- ขวาบน
MainFrame.Size = UDim2.new(0, 85, 0, 85)

-- ปุ่มกด
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- สีดำดุๆ
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "GOD\nLOCK"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.TextSize = 18.000
ToggleBtn.AutoButtonColor = true

UICorner.CornerRadius = UDim.new(1, 0) -- วงกลม
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 4
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- --- ระบบลากปุ่ม (กันบัค) ---
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- --- เปิด/ปิด ---
ToggleBtn.Activated:Connect(function()
    if dragging and (UserInputService:GetMouseLocation() - Vector2.new(dragStart.X, dragStart.Y)).Magnitude > 10 then return end

    getgenv().GodLock = not getgenv().GodLock
    
    if getgenv().GodLock then
        ToggleBtn.Text = "ACTIVE"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 0) -- เขียวแสบตา
        UIStroke.Color = Color3.fromRGB(0, 255, 0)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    else
        ToggleBtn.Text = "GOD\nLOCK"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        UIStroke.Color = Color3.fromRGB(255, 0, 0)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Target = nil
    end
end)

-- --- ฟังก์ชันหาคนใกล้ตัวที่สุด (Nearest Distance) ---
local function GetNearestTarget()
    local ClosestDist = math.huge
    local ClosestPlayer = nil
    
    -- ตำแหน่งตัวเรา
    local MyPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    if not MyPos then return nil end

    for _, v in pairs(Players:GetPlayers()) do
        -- เงื่อนไขพื้นฐาน
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            
            -- เช็คทีม
            if v.Team ~= nil and LocalPlayer.Team ~= nil and v.Team == LocalPlayer.Team then
                continue
            end

            -- วัดระยะห่าง (Magnitude)
            local EnemyPos = v.Character.HumanoidRootPart.Position
            local Dist = (MyPos - EnemyPos).Magnitude
            
            -- ถ้าอยู่ในระยะ และ ใกล้กว่าคนก่อนหน้า ให้เลือกคนนี้
            if Dist < MaxDistance and Dist < ClosestDist then
                ClosestDist = Dist
                ClosestPlayer = v
            end
        end
    end
    return ClosestPlayer
end

-- --- ระบบทำงาน (Heartbeat - เร็วที่สุด) ---
RunService.RenderStepped:Connect(function()
    if getgenv().GodLock then
        -- สแกนหาคนใกล้ตัวตลอดเวลา
        Target = GetNearestTarget()

        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            --[[ 
               THE 1000% LOCK 
               ใช้ CFrame ตรงๆ เพื่อบังคับกล้อง
               ไม่มีการเช็คกำแพง (Wall Check)
               ไม่มีการหน่วง (No Smoothing)
            ]]
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    else
        Target = nil
    end
end)
