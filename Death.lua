--[[
    DELTA SILENT AIMBOT (Generic RemoteEvent Hook)
    - ใช้เทคนิคการดักจับ RemoteEvent เพื่อเล็งเงียบ
    - ไม่ต้องขยับกล้อง
    - ใช้ pcall + HookFunction เพื่อความเสถียร
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

getgenv().SILENT_AIM_ACTIVE = false
local MAX_DISTANCE = 300 -- ระยะสูงสุดที่ Aimbot จะเล็ง

-- **นี่คือชื่อ RemoteEvent ที่ต้องแก้ไขตามเกมที่คุณเล่น!**
-- ตัวอย่างนี้ใช้ชื่อที่พบบ่อย แต่คุณอาจต้องเปลี่ยนเอง (เช่น "Shoot", "DamageEvent", "Fire")
local FIRE_REMOTE_NAME = "FireBullet" 

-- --- 1. SIMPLE GUI TOGGLE ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "SilentAimbotToggle"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

ToggleBtn.Name = "ToggleSilentAim"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 150, 0, 50)
ToggleBtn.Position = UDim2.new(0.01, 0, 0.85, 0) 
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "SILENT AIM OFF"
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

local OriginalFireRemote = nil -- ใช้เก็บ RemoteEvent เดิมก่อน Hook

-- ฟังก์ชันที่ใช้ดักจับ RemoteEvent
local function SilentAimHook(remote, ...)
    pcall(function()
        if getgenv().SILENT_AIM_ACTIVE then
            local TargetPart = GetTarget()
            
            if TargetPart and getgenv().AIMBOT_ACTIVE then
                local HeadPosition = TargetPart.Position
                local MyPosition = LocalPlayer.Character.HumanoidRootPart.Position
                
                local Direction = (HeadPosition - MyPosition).Unit -- ทิศทางใหม่ที่เจาะจงไปที่หัว
                
                -- **นี่คือการปลอมแปลง (Spoofing) ข้อมูลการยิง**
                -- การยิงส่วนใหญ่ส่งพิกัดการเล็ง (LookVector) เป็นอาร์กิวเมนต์ตัวแรก/ตัวที่สอง
                local Args = {...}
                
                -- พยายามแทนที่อาร์กิวเมนต์ที่ 1 ด้วยทิศทางใหม่ (สมมติว่าเป็น LookVector)
                if Args[1] and typeof(Args[1]) == "Vector3" then
                    Args[1] = Direction 
                -- หรือถ้ามันส่งเป็น RaycastOrigin/Direction (ตามรูปแบบการยิงสมัยใหม่)
                elseif Args[2] and typeof(Args[2]) == "Vector3" then
                     Args[2] = Direction
                end
                
                -- ส่งข้อมูลที่ถูกปลอมแปลงแล้วไปยังเซิร์ฟเวอร์
                return OriginalFireRemote(remote, table.unpack(Args))
            end
        end
    end)
    
    -- ถ้าไม่มีการล็อคเป้าหมาย หรือปิด Aimbot อยู่ ให้รันคำสั่งเดิมตามปกติ
    return OriginalFireRemote(remote, ...)
end

-- --- 3. TOGGLE LOGIC ---
ToggleBtn.Activated:Connect(function()
    getgenv().SILENT_AIM_ACTIVE = not getgenv().SILENT_AIM_ACTIVE
    
    if getgenv().SILENT_AIM_ACTIVE then
        ToggleBtn.Text = "SILENT AIM ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

        -- **การค้นหา RemoteEvent และ Hooking**
        local Remote
        pcall(function()
            -- ค้นหา RemoteEvent ใน RepilicatedStorage หรือที่อื่น ๆ ที่พบบ่อย
            Remote = game:GetService("ReplicatedStorage"):FindFirstChild(FIRE_REMOTE_NAME, true)
            if not Remote then 
                 Remote = Workspace:FindFirstChild(FIRE_REMOTE_NAME, true) 
            end
        end)

        if Remote and getgenv().hookfunction then
            game.StarterGui:SetCore("SendNotification", {Text = "RemoteEvent Found. Hooking...", Duration = 3;})
            OriginalFireRemote = getgenv().hookfunction(Remote.FireServer, SilentAimHook)
        else
            game.StarterGui:SetCore("SendNotification", {Text = "ERROR: RemoteEvent ไม่พบ! ต้องแก้ไขชื่อ RemoteEvent.", Duration = 5;})
            getgenv().SILENT_AIM_ACTIVE = false
            ToggleBtn.Text = "FIX REQUIRED"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        end
    else
        ToggleBtn.Text = "SILENT AIM OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        -- ต้องทำการ Unhook เมื่อปิด Aimbot (แต่ทำได้ยากในโค้ดทั่วไป)
        -- ในกรณีนี้จะปล่อยให้ hook อยู่ แต่ปิดการทำงานในฟังก์ชัน SilentAimHook
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Silent Aimbot Loaded";
    Text = "นี่คือการเจาะระบบการยิงโดยตรง กรุณาลองทดสอบการยิง!";
    Duration = 5;
})

