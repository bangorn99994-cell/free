--[[
    FINAL SILENT AIMBOT (3-in-1 REMOTE BYPASS)
    - โค้ดจะลองดักจับ RemoteEvent 3 ชื่อที่พบบ่อยที่สุดในการยิงปืน
    - ใช้ Anti-Kick Logic เพื่อลดโอกาสถูกเตะออก
    - ใช้ pcall เพื่อความเสถียร
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

getgenv().AIMBOT_ACTIVE = false
local MAX_DISTANCE = 350 

-- 🔥🔥🔥 3 ชื่อ RemoteEvent ที่พบบ่อยที่สุด 🔥🔥🔥
local FIRE_REMOTE_NAMES = {
    "FireGun",    -- ชื่อที่ตรงไปตรงมา
    "DamageEvent",-- ชื่อที่เน้นการส่งค่าความเสียหาย
    "WeaponRemote"-- ชื่อที่ถูกใช้ในแพลตฟอร์มปืนสำเร็จรูป
}

-- --- 1. SIMPLE GUI TOGGLE (โค้ด GUI ที่เรียบง่ายที่สุด) ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
ScreenGui.Name = "FinalAimbotGUI"

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

local OriginalFireRemotes = {} -- ใช้เก็บ Original Hook Functions

-- ฟังก์ชันดักจับ (Hook) ที่เน้นความปลอดภัย
local function SilentAimHook(remote, ...)
    pcall(function()
        if getgenv().AIMBOT_ACTIVE then
            local TargetPart = GetTarget()
            
            if TargetPart then
                local HeadPosition = TargetPart.Position
                -- คำนวณทิศทางใหม่โดยใช้ตำแหน่งกล้องเป็นจุดกำเนิด
                local Direction = (HeadPosition - Camera.CFrame.Position).Unit 

                local Args = {...}
                
                -- ANTI-KICK LOGIC: ปลอมแปลงเฉพาะค่า Vector3 ที่เป็น LookVector
                for i, arg in ipairs(Args) do
                    if typeof(arg) == "Vector3" then
                        -- แทนที่ Vector3 แรกด้วยทิศทางใหม่
                        Args[i] = Direction
                        break 
                    end
                end
                
                -- ส่งข้อมูลที่ถูกปลอมแปลงแล้วไปยังเซิร์ฟเวอร์โดยใช้ Original Hook Function
                local originalFunc = OriginalFireRemotes[remote.Name]
                if originalFunc then
                    return originalFunc(remote, table.unpack(Args))
                end
            end
        end
    end)
    
    -- ถ้าการปลอมแปลงล้มเหลว หรือ Aimbot ปิดอยู่ ให้รันคำสั่งเดิม
    local originalFunc = OriginalFireRemotes[remote.Name]
    if originalFunc then
        return originalFunc(remote, ...)
    end
end

-- --- 3. TOGGLE LOGIC ---
ToggleBtn.Activated:Connect(function()
    getgenv().AIMBOT_ACTIVE = not getgenv().AIMBOT_ACTIVE
    
    if getgenv().AIMBOT_ACTIVE then
        ToggleBtn.Text = "AIMBOT ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

        local hookSuccess = false
        -- พยายาม Hook RemoteEvents ทั้ง 3 ชื่อ
        for _, name in ipairs(FIRE_REMOTE_NAMES) do
            pcall(function()
                local Remote = ReplicatedStorage:FindFirstChild(name, true) or Workspace:FindFirstChild(name, true)
                
                if Remote and getgenv().hookfunction then
                    -- ทำการ Hook และเก็บ Original Function ไว้
                    OriginalFireRemotes[name] = getgenv().hookfunction(Remote.FireServer, SilentAimHook)
                    hookSuccess = true
                    print("Hooked: " .. name)
                end
            end)
        end

        if hookSuccess then
            game.StarterGui:SetCore("SendNotification", {Title = "Silent Aimbot Hooked"; Text = "ลองยิงปืน! Aimbot กำลังดักจับ 3 RemoteEvents ที่พบบ่อย.", Duration = 4;})
        else
            game.StarterGui:SetCore("SendNotification", {Title = "ERROR"; Text = "ไม่พบ RemoteEvent ที่ตรงกัน! คุณต้องใช้ Remote Spy เพื่อหาชื่อที่ถูกต้อง.", Duration = 5;})
            getgenv().AIMBOT_ACTIVE = false
            ToggleBtn.Text = "FIX REQUIRED"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        end
    else
        ToggleBtn.Text = "AIMBOT OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
