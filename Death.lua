--[[
    DELTA WAR HACK (FINAL AGGRESSIVE SAFE-CALL FIX)
    - ใช้ pcall ครอบทุกคำสั่งสำคัญ เพื่อให้โค้ดทนทานต่อ Anti-Cheat
    - ใช้ coroutine.wrap + Heartbeat เพื่อความถี่สูงสุดในการเจาะระบบ
    - Chams X-Ray (Highlight DepthMode.AlwaysOnTop)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

getgenv().ESP_ACTIVE = false
local CHAMS_COLOR = Color3.fromRGB(0, 255, 255) -- สีฟ้านีออน

-- --- 1. SIMPLE GUI TOGGLE (แก้ปัญหาปุ่มกดไม่ติด) ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "AggressiveChamsToggle"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

ToggleBtn.Name = "ToggleChams"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 150, 0, 50)
ToggleBtn.Position = UDim2.new(0.01, 0, 0.85, 0) 
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "CHAMS OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18

-- --- 2. CORE CHAMS LOGIC (พร้อม pcall ครอบทุกบรรทัด) ---

local function ApplyChams(part)
    if not part:IsA("BasePart") and not part:IsA("MeshPart") then return end
    
    -- โค้ดทุกบรรทัดต้องถูกห่อหุ้มด้วย pcall ในลูปหลัก
    
    -- 1. เปลี่ยน Material และสี
    pcall(function() part.Material = Enum.Material.Neon end) 
    pcall(function() part.Color = CHAMS_COLOR end)
    pcall(function() part.Transparency = 0.5 end)
    
    -- 2. สร้าง Highlight (การมองทะลุ)
    local success, h = pcall(function() return part:FindFirstChild("Highlight") or Instance.new("Highlight") end)
    
    if success and h and h:IsA("Highlight") then
        pcall(function() h.FillTransparency = 0 end)
        pcall(function() h.DepthMode = Enum.DepthMode.AlwaysOnTop end) -- **โค้ดเจาะระบบ**
        pcall(function() h.FillColor = CHAMS_COLOR end)
        pcall(function() h.Parent = part end)
        pcall(function() h.Enabled = true end)
    end
end

local function RemoveChams(part)
    if not part:IsA("BasePart") and not part:IsA("MeshPart") then return end
    pcall(function()
        part.Material = Enum.Material.Plastic 
        part.Transparency = 0
        local h = part:FindFirstChild("Highlight")
        if h then h:Destroy() end
    end)
end

local function HandlePlayer(player)
    local function ReapplyLoop(character)
        -- ลูปการทำงานที่รันใน Thread แยก (coroutine.wrap)
        while getgenv().ESP_ACTIVE and character and character.Parent do
            -- pcall ครอบทั้งลูปย่อยเพื่อความปลอดภัยสูงสุด
            pcall(function()
                for _, part in pairs(character:GetDescendants()) do
                    ApplyChams(part)
                end
            end)
            -- ใช้ Heartbeat เพื่อความถี่สูงสุด (60+ ครั้งต่อวินาที)
            RunService.Heartbeat:Wait()
        end
        
        -- ลบ Chams ออกเมื่อลูปหยุดทำงาน
        pcall(function()
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    RemoveChams(part)
                end
            end
        end)
    end
    
    -- เมื่อตัวละครเกิด/เข้าเกม ให้เริ่มลูปใหม่ด้วย coroutine.wrap
    player.CharacterAdded:Connect(function(character)
        if getgenv().ESP_ACTIVE then
            coroutine.wrap(ReapplyLoop)(character)
        end
    end)
    
    -- เริ่มต้นทันทีถ้ามีตัวละครอยู่แล้ว
    if player.Character and getgenv().ESP_ACTIVE then
        coroutine.wrap(ReapplyLoop)(player.Character)
    end
end

-- --- 3. TOGGLE LOGIC (การเปิด/ปิด) ---
ToggleBtn.Activated:Connect(function()
    getgenv().ESP_ACTIVE = not getgenv().ESP_ACTIVE
    
    if getgenv().ESP_ACTIVE then
        ToggleBtn.Text = "CHAMS ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and (v.Team == nil or v.Team ~= LocalPlayer.Team) then
                HandlePlayer(v)
            end
        end
    else
        ToggleBtn.Text = "CHAMS OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                for _, part in pairs(v.Character:GetDescendants()) do
                    RemoveChams(part)
                end
            end
        end
    end
end)

-- --- 4. INITIAL SETUP ---
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        HandlePlayer(v)
    end
end
Players.PlayerAdded:Connect(function(v)
    if v ~= LocalPlayer then
        HandlePlayer(v)
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Aggressive Chams Loaded";
    Text = "ใช้เทคนิค pcall ครอบทุกคำสั่งเพื่อป้องกัน Anti-Cheat";
    Duration = 5;
})
