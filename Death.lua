-- // Speed Hack สำหรับ Delta Executor (ปรับได้สูงสุด 500)
-- กด F เพื่อเปิด/ปิด | ใช้ลูกศรขึ้น-ลง ปรับความเร็ว

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ค่าพื้นฐาน
local SpeedEnabled = false
local CurrentSpeed = 100  -- ความเร็วเริ่มต้น (100 = 5 เท่าของปกติ)
local MaxSpeed = 500      -- ความเร็วสูงสุดที่ตั้งไว้
local MinSpeed = 16       -- ความเร็วต่ำสุด (16 = เดิม)

-- แสดงสถานะ
local function Notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Speed Hack";
        Text = text;
        Duration = 2;
    })
end

Notify("Speed Hack โหลดแล้ว! กด F เพื่อเปิด/ปิด")

-- ฟังก์ชันตั้งค่าความเร็ว
local function SetSpeed(speed)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = speed
    end
end

-- เปิด/ปิด Speed
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        SpeedEnabled = not SpeedEnabled
        
        if SpeedEnabled then
            SetSpeed(CurrentSpeed)
            Notify("Speed ON | ความเร็ว: " .. CurrentSpeed)
        else
            SetSpeed(16) -- คืนค่าเดิม
            Notify("Speed OFF")
        end
    end
    
    -- ปรับความเร็วด้วยลูกศร (เมื่อเปิดอยู่เท่านั้น)
    if SpeedEnabled then
        if input.KeyCode == Enum.KeyCode.Up then
            CurrentSpeed = math.clamp(CurrentSpeed + 10, MinSpeed, MaxSpeed)
            SetSpeed(CurrentSpeed)
            Notify("ความเร็ว: " .. CurrentSpeed)
        elseif input.KeyCode == Enum.KeyCode.Down then
            CurrentSpeed = math.clamp(CurrentSpeed - 10, MinSpeed, MaxSpeed)
            SetSpeed(CurrentSpeed)
            Notify("ความเร็ว: " .. CurrentSpeed)
        end
    end
end)

-- รักษาความเร็วเมื่อรีสปอนด์
Player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    wait(0.5)
    if SpeedEnabled then
        hum.WalkSpeed = CurrentSpeed
    else
        hum.WalkSpeed = 16
    end
end)

-- ป้องกันการรีเซ็ตจากเกมบางเกม (Loop ป้องกัน)
RunService.Heartbeat:Connect(function()
    if SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if Player.Character.Humanoid.WalkSpeed ~= CurrentSpeed then
            Player.Character.Humanoid.WalkSpeed = CurrentSpeed
        end
    end
end)
