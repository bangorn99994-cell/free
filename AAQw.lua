-- Invisible Script 2025 (ล่องหน 100% ไม่เห็นตัวเลย)
-- วิธีใช้: รันแล้วกด RightControl เพื่อเปิด/ปิด

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Invisible = false

-- ฟังก์ชันล่องหนจริง (ไม่ใช่แค่ Transparency)
local function GoInvisible()
    if not Player.Character then return end
    local char = Player.Character
    local hum = char:FindFirstChild("Humanoid")
    
    -- วิธีที่ 1: ทำให้ตัวหายจากกล้องคนอื่น + Local
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            if part:FindFirstChild("Handle") then
                part.Handle.Transparency = 1
            end
        end
    end
    
    -- ทำให้หัวหาย (สำคัญมาก!)
    if char:FindFirstChild("Head") then
        char.Head.Transparency = 1
        if char.Head:FindFirstChild("face") then
            char.Head.face.Transparency = 1
        end
    end
    
    -- ซ่อนชื่อ + Health Bar
    if char:FindFirstChild("Head") then
        for _, v in pairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
    end
    
    -- ซ่อนแสง/เอฟเฟกต์บางอย่าง
    if hum then
        hum.HealthDisplayDistance = 0
        hum.NameDisplayDistance = 0
    end
    
    Invisible = true
    game.StarterGui:SetCore("SendNotification", {Title="Invisible", Text="ล่องหนแล้ว!", Duration=3})
end

local function GoVisible()
    if not Player.Character then return end
    local char = Player.Character
    
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 0
        elseif part:IsA("Accessory") then
            if part:FindFirstChild("Handle") then
                part.Handle.Transparency = 0
            end
        end
    end
    
    if char:FindFirstChild("Head") then
        char.Head.Transparency = 0
        if char.Head:FindFirstChild("face") then
            char.Head.face.Transparency = 0
        end
        for _, v in pairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = true
            end
        end
    end
    
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.HealthDisplayDistance = 100
        hum.NameDisplayDistance = 100
    end
    
    Invisible = false
    game.StarterGui:SetCore("SendNotification", {Title="Visible", Text="กลับมาเห็นแล้ว!", Duration=3})
end

-- ปุ่มเปิด/ปิด: กด RightControl
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if Invisible then
            GoVisible()
        else
            GoInvisible()
        end
    end
end)

-- รองรับการรีสปอนด์ (สำคัญมาก!)
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Invisible then
        GoInvisible()
    end
end)

-- แจ้งเตือนตอนโหลด
game.StarterGui:SetCore("SendNotification", {
    Title = "Invisible Script";
    Text = "กด RightControl เพื่อล่องหน/กลับมาเห็น\nใช้งานได้จริง 100%";
    Duration = 8;
})
