-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Settings (ตั้งค่า)
local Settings = {
    AimKey = Enum.UserInputType.MouseButton2, -- ปุ่มกดเพื่อล็อค (คลิกขวา)
    TeamCheck = true, -- เช็คทีม (true = ไม่ล็อคพวกเดียวกัน / false = ล็อคทุกคน)
    Sensitivity = 0.5, -- ความหน่วงในการล็อค (ยิ่งน้อยยิ่งล็อคติดหัวแน่น, 1 คือล็อคทันที)
    FOV = 400 -- รัศมีวงกลมรอบเมาส์ที่จะทำการล็อค
}

local Locking = false
local Target = nil

-- ฟังก์ชันหาผู้เล่นที่ใกล้เมาส์ที่สุด
local function GetClosestPlayer()
    local MaxDistance = Settings.FOV
    local ClosestTarget = nil
    local MousePos = UserInputService:GetMouseLocation()

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            -- Team Check
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then
                continue
            end

            -- คำนวณตำแหน่งบนจอ
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen then
                local Distance = (Vector2.new(Pos.X, Pos.Y) - MousePos).Magnitude
                if Distance < MaxDistance then
                    MaxDistance = Distance
                    ClosestTarget = v
                end
            end
        end
    end
    return ClosestTarget
end

-- ตรวจจับการกดปุ่ม
UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Settings.AimKey then
        Locking = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Settings.AimKey then
        Locking = false
        Target = nil
    end
end)

-- ระบบล็อคเป้า (ทำงานทุกเฟรม)
RunService.RenderStepped:Connect(function()
    if Locking then
        -- หาเป้าหมายใหม่ถ้ายังไม่มี หรือเป้าหมายเดิมตาย/หายไป
        if not Target or not Target.Character or not Target.Character:FindFirstChild("Head") or Target.Character.Humanoid.Health <= 0 then
            Target = GetClosestPlayer()
        end

        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            -- คำนวณตำแหน่งหัว
            local HeadPos = Target.Character.Head.Position
            
            -- ล็อคกล้องไปที่หัว
            local CurrentCFrame = Camera.CFrame
            local TargetCFrame = CFrame.new(CurrentCFrame.Position, HeadPos)
            
            -- ใช้ Tween/Lerp เพื่อความสมูท (หรือปรับ Sensitivity เป็น 1 เพื่อล็อคทันที)
            Camera.CFrame = CurrentCFrame:Lerp(TargetCFrame, Settings.Sensitivity)
        end
    else
        Target = nil
    end
end)

-- แจ้งเตือนเมื่อรันสคริปต์เสร็จ
game.StarterGui:SetCore("SendNotification", {
    Title = "AutoLock Loaded";
    Text = "Hold Right Click to Lock Head";
    Duration = 5;
})
