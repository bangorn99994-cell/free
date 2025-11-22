-- Gui to Lua
-- Version: Delta Mobile Optimized

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- ตัวแปรควบคุม
getgenv().AutoLock = false -- เริ่มต้นปิด
local Target = nil

-- 1. สร้างปุ่ม GUI (สำหรับ Delta/Mobile)
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "DeltaAutoLock"
-- พยายามนำเข้า CoreGui ถ้าไม่ได้ให้ไป PlayerGui
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBtn.Position = UDim2.new(0.8, -60, 0.3, 0) -- อยู่ขวาบน (ลากได้)
ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "LOCK"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16.000
ToggleBtn.Draggable = true -- ลากได้
ToggleBtn.Active = true
ToggleBtn.AutoButtonColor = true

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

StatusLabel.Parent = ToggleBtn
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
StatusLabel.Position = UDim2.new(0.7, 0, 0.7, 0)
StatusLabel.Size = UDim2.new(0, 15, 0, 15)
StatusLabel.Text = ""
StatusLabel.UICorner = Instance.new("UICorner", StatusLabel)
StatusLabel.UICorner.CornerRadius = UDim.new(1, 0)

-- 2. ฟังก์ชันหาเป้าหมาย (Closest to Center)
local function GetClosestEnemy()
    local ClosestDist = math.huge
    local ClosestTarget = nil
    
    -- ใช้จุดกึ่งกลางหน้าจอแทนเมาส์ (เหมาะกับมือถือ)
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        -- เงื่อนไข: ไม่ใช่ตัวเอง, มีตัวละคร, มีหัว, ยังไม่ตาย
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            
            -- เช็คทีม (ถ้ามีระบบทีม)
            if v.Team ~= nil and LocalPlayer.Team ~= nil and v.Team == LocalPlayer.Team then
                continue
            end

            -- เช็คว่าอยู่ในหน้าจอไหม
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

-- 3. การทำงานปุ่มกด (Toggle)
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().AutoLock = not getgenv().AutoLock
    
    if getgenv().AutoLock then
        StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- สีเขียว (เปิด)
        UIStroke.Color = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 4) -- สีแดง (ปิด)
        UIStroke.Color = Color3.fromRGB(255, 255, 255)
        Target = nil
    end
end)

-- 4. ลูปการทำงานแบบ 100% Lock (RenderStepped)
RunService.RenderStepped:Connect(function()
    if getgenv().AutoLock then
        -- ถ้าเป้าหมายเดิมตาย หรือ หายไป ให้หาใหม่
        if not Target or not Target.Character or not Target.Character:FindFirstChild("Head") or Target.Character.Humanoid.Health <= 0 then
            Target = GetClosestEnemy()
        end

        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            -- *** ส่วนสำคัญ: Hard Lock ***
            -- ตั้งค่า CFrame ของกล้องไปที่หัวเป้าหมายทันทีโดยไม่มี Lerp
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    else
        Target = nil
    end
end)

-- แจ้งเตือน
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Delta Lock Loaded";
    Text = "Button is on screen! Drag to move.";
    Duration = 3;
})
