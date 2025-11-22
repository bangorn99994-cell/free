--[[
    DELTA WAR HACK (AIMBOT / AIM LOCK)
    - โค้ดล็อคหัวไปยังศัตรูที่ใกล้ที่สุด
    - ใช้ pcall + Heartbeat Loop เพื่อความเสถียร
    - สามารถปรับระยะการล็อคได้ (Max Distance)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().AIMBOT_ACTIVE = false
local MAX_DISTANCE = 300 -- ระยะสูงสุดที่ Aimbot จะล็อคเป้า (หน่วย Studs)

-- --- 1. SIMPLE GUI TOGGLE (ปุ่มเปิด/ปิด Aimbot) ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "AimbotToggle"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

ToggleBtn.Name = "ToggleAimbot"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 150, 0, 50)
ToggleBtn.Position = UDim2.new(0.01, 0, 0.85, 0) 
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "AIMBOT OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18

-- --- 2. CORE AIMBOT LOGIC ---

-- ฟังก์ชันหาเป้าหมายที่ดีที่สุด (ใกล้ที่สุด)
local function GetTarget()
    local BestTarget = nil
    local ClosestDistance = MAX_DISTANCE
    local MyHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not MyHRP then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 and (player.Team == nil or player.Team ~= LocalPlayer.Team) then
            local TargetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if TargetPart then
                local Distance = (MyHRP.Position - TargetPart.Position).Magnitude
                
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    BestTarget = TargetPart
                end
            end
        end
    end
    return BestTarget
end

-- ลูปหลัก Aimbot
local function AimbotLoop()
    while getgenv().AIMBOT_ACTIVE do
        pcall(function()
            local Target = GetTarget()
            
            if Target then
                local TargetPos = Target.Position
                local CameraCFrame = Camera.CFrame
                
                -- คำนวณ CFrame ใหม่เพื่อล็อคหัว
                local NewCFrame = CFrame.new(CameraCFrame.p, TargetPos)
                
                -- ล็อคกล้อง
                Camera.CFrame = NewCFrame
            end
        end)
        
        -- ใช้ Heartbeat เพื่อให้ล็อคหัวได้อย่างรวดเร็วและแม่นยำสูงสุด
        RunService.Heartbeat:Wait()
    end
end

-- --- 3. TOGGLE LOGIC ---
ToggleBtn.Activated:Connect(function()
    getgenv().AIMBOT_ACTIVE = not getgenv().AIMBOT_ACTIVE
    
    if getgenv().AIMBOT_ACTIVE then
        ToggleBtn.Text = "AIMBOT ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- เริ่มต้น Aimbot Loop ด้วย coroutine.wrap ทันที
        coroutine.wrap(AimbotLoop)()
    else
        ToggleBtn.Text = "AIMBOT OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Aimbot Loaded";
    Text = "Aimbot พร้อมใช้งานแล้ว (ระยะล็อค " .. MAX_DISTANCE .. " Studs).";
    Duration = 5;
})
