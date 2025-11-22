-- Delta Mobile AutoLock (Fixed Touch & Drag)
-- แก้ไข: ปุ่มกดไม่ติด / ล็อค 100%

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ตั้งค่าเริ่มต้น
getgenv().AutoLock = false 
local Target = nil

-- --- สร้าง GUI ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame") -- ใช้ Frame เป็นตัวหลักเพื่อให้ลากง่าย
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local StatusText = Instance.new("TextLabel")

ScreenGui.Name = "DeltaFixGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- พยายามหาที่วาง GUI ที่ปลอดภัยที่สุด
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ตัวกรอบหลัก (ใช้สำหรับลาก)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1.000
MainFrame.Position = UDim2.new(0.75, 0, 0.25, 0) -- ตำแหน่งขวาบน
MainFrame.Size = UDim2.new(0, 80, 0, 80)

-- ตัวปุ่ม (กดเพื่อเปิด/ปิด)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40) -- สีแดง
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.Font = Enum.Font.FredokaOne
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 24.000
ToggleBtn.AutoButtonColor = true

UICorner.CornerRadius = UDim.new(1, 0) -- กลมดิ๊ก
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 255, 255)

-- --- ระบบลากปุ่ม (Custom Dragging) ---
-- เขียนใหม่ไม่ใช้ Draggable=true เพื่อไม่ให้บัคปุ่มกด
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- --- ระบบเปิด/ปิด (Toggle Logic) ---
-- ใช้ Activated จะติดง่ายกว่าในมือถือ
ToggleBtn.Activated:Connect(function()
    -- เช็คว่ากำลังลากอยู่ไหม ถ้าลากอยู่จะไม่กดปุ่ม
    if dragging and (UserInputService:GetMouseLocation() - Vector2.new(dragStart.X, dragStart.Y)).Magnitude > 10 then
        return -- ถ้าขยับนิ้วเกิน 10 pixel ถือว่าลาก ไม่กด
    end

    getgenv().AutoLock = not getgenv().AutoLock
    
    if getgenv().AutoLock then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- สีเขียว
    else
        ToggleBtn.Text = "OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40) -- สีแดง
        Target = nil
    end
end)

-- --- ระบบล็อคหัว (Aimbot Logic) ---
local function GetClosestEnemy()
    local ClosestDist = math.huge
    local ClosestTarget = nil
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            -- Team Check
            if v.Team ~= nil and LocalPlayer.Team ~= nil and v.Team == LocalPlayer.Team then
                continue
            end

            local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen then
                local Dist = (Vector2.new(Vector.X, Vector.Y) - Center).Magnitude
                if Dist < ClosestDist then
                    ClosestDist = Dist
                    ClosestTarget = v
                end
            end
        end
    end
    return ClosestTarget
end

RunService.RenderStepped:Connect(function()
    if getgenv().AutoLock then
        if not Target or not Target.Character or not Target.Character:FindFirstChild("Head") or Target.Character.Humanoid.Health <= 0 then
            Target = GetClosestEnemy()
        end

        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            -- HARD LOCK 100% (ไม่มี Lerp)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    else
        Target = nil
    end
end)

-- แจ้งเตือน
game.StarterGui:SetCore("SendNotification", {
    Title = "Fixed Touch";
    Text = "Tap button to toggle Lock!";
    Duration = 3;
})
