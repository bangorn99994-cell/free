--[[
    FINAL AIMBOT (AUTO-INJECT - NO GUI)
    - โค้ดจะเริ่มทำงานทันทีที่รัน
    - ใช้ pcall + Heartbeat เพื่อความเสถียรสูงสุด
    - ใช้ CameraType.Scriptable และ Lerp เพื่อหลีกเลี่ยง Anti-Cheat Camera Check
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AIMBOT_ACTIVE = true -- เปิดใช้งานทันที
local MAX_DISTANCE = 350 -- เพิ่มระยะเล็กน้อย
local AIMBOT_SMOOTH = 0.3 -- ล็อคเร็วขึ้น (ลดค่าจาก 0.5)

-- --- CORE AIMBOT LOGIC ---

local function GetTarget()
    local BestTarget = nil
    local ClosestDistance = MAX_DISTANCE
    local MyHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not MyHRP then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        -- ตรวจสอบ Team/Health
        if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 and (player.Team == nil or player.Team ~= LocalPlayer.Team) then
            -- เล็งไปที่ศีรษะ (Head)
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

-- ลูปหลัก Aimbot (ใช้ Coroutine และ pcall)
local function AimbotLoop()
    -- ใช้ pcall ครอบทั้ง Coroutine เพื่อความเสถียรสูงสุด
    pcall(function()
        while AIMBOT_ACTIVE do
            local Target = GetTarget()
            
            pcall(function()
                if Target then
                    local TargetPos = Target.Position
                    
                    -- เทคนิค BYPASS: ตั้งค่ากล้องเป็น Scriptable ก่อน
                    Camera.CameraType = Enum.CameraType.Scriptable
                    
                    local TargetCFrame = CFrame.new(Camera.CFrame.p, TargetPos)
                    
                    -- ใช้ Lerp เพื่อการล็อคที่นุ่มนวลและป้องกันการ Revert
                    Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, AIMBOT_SMOOTH)
                    
                    -- คืนค่ากล้องเป็น Custom หลังจบเฟรม
                    Camera.CameraType = Enum.CameraType.Custom
                else
                    -- ถ้าไม่มีเป้าหมาย ให้คืนค่ากล้องปกติ
                    Camera.CameraType = Enum.CameraType.Custom
                end
            end)
            
            -- ใช้ Heartbeat เพื่อให้ล็อคหัวได้อย่างรวดเร็ว
            RunService.Heartbeat:Wait()
        end
    end)
    -- มั่นใจว่ากล้องกลับสู่โหมด Custom เมื่อโค้ดหยุด
    pcall(function() Camera.CameraType = Enum.CameraType.Custom end)
end

-- --- INITIALIZATION (เริ่มต้นทันที) ---
-- โค้ดจะถูกรันใน Coroutine ใหม่ทันทีที่ Executor รันสคริปต์นี้
coroutine.wrap(AimbotLoop)()

game.StarterGui:SetCore("SendNotification", {
    Title = "Aimbot Auto-Inject Loaded";
    Text = "Aimbot ทำงานทันทีที่รันโค้ด (ไม่มีเมนู).";
    Duration = 5;
})
