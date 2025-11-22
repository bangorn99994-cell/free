--[[
    DELTA SILENT AIMBOT (FINAL ANTI-KICK BYPASS)
    - ใช้เทคนิคการดักจับฟังก์ชันภายใน (Gun Function) แทน FireServer โดยตรง
    - การปลอมแปลงข้อมูลจะทำอย่างระมัดระวังเพื่อลดการถูกเตะออก
    - โค้ดนี้คือที่สุดของการพยายามหลีกเลี่ยง Anti-Cheat
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().AIMBOT_ACTIVE = false
local MAX_DISTANCE = 300 

-- 🔥🔥🔥 ส่วนที่ต้องแก้ไขเอง: ชื่อ RemoteEvent 🔥🔥🔥
-- ถ้าโค้ดไม่ทำงาน คุณต้องใช้ Remote Spy หาชื่อ RemoteEvent ของการยิงปืน 
-- และนำมาใส่แทนที่ "WeaponRemote"
local FIRE_REMOTE_NAME = "WeaponRemote" -- ชื่อ RemoteEvent ที่พบบ่อยในเกมต่อสู้

-- --- 1. SIMPLE GUI TOGGLE ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
ScreenGui.Name = "FinalAntiKickAimbot"

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
        -- ตรวจสอบ Team/Health
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

local OriginalFireRemote = nil

-- ฟังก์ชันดักจับ (Hook) ที่เน้นความปลอดภัย (Anti-Kick)
local function SilentAimHook(remote, ...)
    pcall(function()
        if getgenv().AIMBOT_ACTIVE then
            local TargetPart = GetTarget()
            
            if TargetPart then
                local HeadPosition = TargetPart.Position
                local MyHRP = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart
                if not MyHRP then return end
                
                -- คำนวณทิศทางใหม่
                local Direction = (HeadPosition - Camera.CFrame.Position).Unit -- ใช้ CFrame กล้องเพื่อความแม่นยำ

                local Args = {...}
                
                -- 🔥 ANTI-KICK LOGIC: ปลอมแปลงเฉพาะค่า LookVector 🔥
                -- Aimbot ส่วนใหญ่ถูกเตะเพราะส่งค่าผิดประเภท (เช่น ส่ง string แทน Vector3)
                -- เราจะตรวจสอบและปลอมแปลงเฉพาะค่า Vector3 ที่เป็น LookVector
                for i, arg in ipairs(Args) do
                    if typeof(arg) == "Vector3" then
                        -- สมมติว่า Vector3 ตัวแรกคือทิศทางการยิง
                        Args[i] = Direction
                        break 
                    end
                end
                
                -- ส่งข้อมูลที่ถูกปลอมแปลงแล้วไปยังเซิร์ฟเวอร์
                return OriginalFireRemote(remote, table.unpack(Args))
            end
        end
    end)
    
    -- ถ้าการปลอมแปลงล้มเหลว หรือ Aimbot ปิดอยู่ ให้รันคำสั่งเดิม
    return OriginalFireRemote(remote, ...)
end

-- --- 3. TOGGLE LOGIC ---
ToggleBtn.Activated:Connect(function()
    getgenv().AIMBOT_ACTIVE = not getgenv().AIMBOT_ACTIVE
    
    if getgenv().AIMBOT_ACTIVE then
        ToggleBtn.Text = "AIMBOT ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

        local Remote
        pcall(function()
            -- พยายามหา RemoteEvent ตามชื่อที่ตั้งไว้
            Remote = game:GetService("ReplicatedStorage"):FindFirstChild(FIRE_REMOTE_NAME, true)
            if not Remote then 
                 Remote = workspace:FindFirstChild(FIRE_REMOTE_NAME, true) 
            end
        end)

        if Remote and getgenv().hookfunction then
            game.StarterGui:SetCore("SendNotification", {Text = "RemoteEvent Found. Hooking (Anti-Kick Mode)...", Duration = 3;})
            -- Hook function เพื่อดักจับการยิง
            OriginalFireRemote = getgenv().hookfunction(Remote.FireServer, SilentAimHook)
        else
            game.StarterGui:SetCore("SendNotification", {Text = "ERROR: ต้องแก้ไข FIRE_REMOTE_NAME เพื่อป้องกันการเตะออก!", Duration = 5;})
            getgenv().AIMBOT_ACTIVE = false
            ToggleBtn.Text = "FIX REQUIRED"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        end
    else
        ToggleBtn.Text = "AIMBOT OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Anti-Kick Silent Aimbot Loaded";
    Text = "นี่คือการเจาะระบบการยิงโดยตรง พร้อม Anti-Kick Logic.";
    Duration = 5;
})
