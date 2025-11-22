--[[ 
    Delta Rage Lock (Wall Check Removed)
    - Hard Lock 100%
    - Locks Through Walls (ล็อคทะลุกำแพง)
    - Fixed Mobile Touch
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ตั้งค่าการล็อค
getgenv().RageLock = false 
local Target = nil

-- --- GUI Setup (เหมือนเดิมแต่ปรับให้เสถียร) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local StatusText = Instance.new("TextLabel")

ScreenGui.Name = "RageLockGUI"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1.000
MainFrame.Position = UDim2.new(0.85, -50, 0.4, 0) -- ขวาเกือบกลาง
MainFrame.Size = UDim2.new(0, 70, 0, 70)

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Text = "WALL\nLOCK"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0) -- เริ่มต้นสีแดง
ToggleBtn.TextSize = 14.000
ToggleBtn.AutoButtonColor = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- --- ระบบลากปุ่ม (Drag System) ---
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

-- --- ปุ่มเปิด/ปิด ---
ToggleBtn.Activated:Connect(function()
    if dragging and (UserInputService:GetMouseLocation() - Vector2.new(dragStart.X, dragStart.Y)).Magnitude > 10 then return end
    
    getgenv().RageLock = not getgenv().RageLock
    
    if getgenv().RageLock then
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        UIStroke.Color = Color3.fromRGB(0, 255, 0)
        ToggleBtn.Text = "ON"
    else
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        UIStroke.Color = Color3.fromRGB(255, 0, 0)
        ToggleBtn.Text = "WALL\nLOCK"
        Target = nil
    end
end)

-- --- ฟังก์ชันหาศัตรู (ไม่สนกำแพง) ---
local function GetTarget()
    local ClosestDist = math.huge
    local ClosestTarget = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        -- 1. ไม่ใช่ตัวเอง + มีตัวละคร + มีหัว + ยังไม่ตาย
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            
            -- 2. เช็คทีม (ถ้ามี)
            if v.Team ~= nil and LocalPlayer.Team ~= nil and v.Team == LocalPlayer.Team then
                continue
            end

            -- 3. คำนวณระยะห่างจากตัวเรา (Distance)
            -- เราใช้ระยะห่างจริงในแมพ แทนที่จะดูว่าอยู่ในจอไหม เพื่อให้ล็อคคนข้างหลังกำแพงได้
            local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            
            -- ล็อคคนที่มีระยะใกล้ตัวเราที่สุด (ในระยะ 500 เมตร)
            if Dist < ClosestDist and Dist < 500 then
                ClosestDist = Dist
                ClosestTarget = v
            end
        end
    end
    return ClosestTarget
end

-- --- ระบบ Rage Lock (ทำงานทุกเฟรม) ---
RunService.RenderStepped:Connect(function()
    if getgenv().RageLock then
        -- หาเป้าหมายตลอดเวลา เพื่อเปลี่ยนเป้าทันทีถ้ามีคนใกล้กว่า
        Target = GetTarget()

        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            -- ** HARD LOCK 100% **
            -- บังคับกล้องหันไปที่หัวศัตรูทันที ไม่มีความหน่วง
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    else
        Target = nil
    end
end)

