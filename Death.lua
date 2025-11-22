-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local AimbotEnabled = false
local Target = nil

-- 1. สร้าง GUI (ปุ่มลอย)
local ScreenGui = Instance.new("ScreenGui")
local MainButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "SimpleAimbotGUI"
if syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui) 
    ScreenGui.Parent = game.CoreGui 
elseif getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
else
    ScreenGui.Parent = game.CoreGui
end

-- ตั้งค่าปุ่ม
MainButton.Name = "ToggleBtn"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60) -- สีแดง (ปิดอยู่)
MainButton.Position = UDim2.new(0.1, 0, 0.2, 0) -- ตำแหน่งเริ่มต้น
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Font = Enum.Font.FredokaOne
MainButton.Text = "OFF"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 20.000
MainButton.Draggable = true -- ทำให้ลากได้ (สำหรับมือถือ)
MainButton.Active = true
MainButton.Selectable = true

UICorner.CornerRadius = UDim.new(0, 100) -- ทำให้กลม
UICorner.Parent = MainButton

UIStroke.Parent = MainButton
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 255, 255)

-- 2. ฟังก์ชันหาหัวคน (Logic)
local function GetClosestPlayer()
    local ClosestDist = 99999
    local ClosestTarget = nil
    local MousePos = UserInputService:GetMouseLocation()

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            -- เช็คทีม (ถ้ามีทีมเดียวกันจะไม่ล็อค)
            if v.Team ~= nil and LocalPlayer.Team ~= nil and v.Team == LocalPlayer.Team then
                continue
            end

            local HeadPos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen then
                local Dist = (Vector2.new(HeadPos.X, HeadPos.Y) - MousePos).Magnitude
                if Dist < ClosestDist then
                    ClosestDist = Dist
                    ClosestTarget = v
                end
            end
        end
    end
    return ClosestTarget
end

-- 3. การทำงานของปุ่ม (Toggle)
MainButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    
    if AimbotEnabled then
        MainButton.Text = "ON"
        MainButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60) -- สีเขียว
        
        -- เล่นเสียงคลิก
        local Sound = Instance.new("Sound")
        Sound.Parent = game.SoundService
        Sound.SoundId = "rbxassetid://12221967"
        Sound.PlayOnRemove = true
        Sound:Destroy()
    else
        MainButton.Text = "OFF"
        MainButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60) -- สีแดง
        Target = nil
    end
end)

-- 4. ลูปการทำงาน (RenderStepped)
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        -- หาเป้าหมายใหม่ถ้ายังไม่มี หรือเป้าหมายเก่าตาย
        if not Target or not Target.Character or not Target.Character:FindFirstChild("Head") or Target.Character.Humanoid.Health <= 0 then
            Target = GetClosestPlayer()
        end

        -- ถ้ามีเป้าหมาย ให้หันกล้องไปหา
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local HeadPos = Target.Character.Head.Position
            
            -- วิธีหันกล้องแบบ Smooth (ไม่กระชากแรงเกินไป)
            local CurrentCFrame = Camera.CFrame
            local TargetCFrame = CFrame.new(CurrentCFrame.Position, HeadPos)
            Camera.CFrame = CurrentCFrame:Lerp(TargetCFrame, 0.2) -- แก้เลข 0.2 เพื่อปรับความไว (0.1 ช้า - 1.0 เร็วสุด)
        end
    else
        Target = nil
    end
end)

-- แจ้งเตือน
game.StarterGui:SetCore("SendNotification", {
    Title = "Simple Lock";
    Text = "Script Loaded! Button is on screen.";
    Duration = 3;
})
