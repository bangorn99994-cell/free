--[[
    DELTA BOX ESP PANEL
    - สร้าง Panel พร้อมปุ่มเปิด/ปิด
    - Box ESP พร้อมเทคนิค Anti-Destroy/Respawn Fix
    - ใช้ได้กับทุกแมพ (ไม่เช็คทีม)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().ESP_ACTIVE = false

-- --- 1. GUI PANEL SETUP (หน้าต่างเมนู) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local TitleLabel = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "ESPHackPanel"
-- หาที่วาง GUI ที่ปลอดภัยที่สุด (สำหรับ Delta)
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- กรอบเมนูหลัก
MainFrame.Name = "ESP_Panel"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0) -- ตำแหน่งซ้ายกลาง
MainFrame.Size = UDim2.new(0, 150, 0, 120)

-- หัวข้อ
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "BOX ESP"
TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.TextSize = 15.000

-- สถานะ (Status)
StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.Position = UDim2.new(0, 0, 1, -20)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "STATUS: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.TextSize = 14.000

-- ปุ่มเปิด/ปิด
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ACTIVATE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16.000

-- ระบบลาก Panel
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)


-- --- 2. ESP CORE LOGIC (พร้อม Anti-Destroy) ---

local function CreateBox(player)
    local character = player.Character
    if not character then return end
    
    local HRP = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    
    if HRP then
        -- ลบของเก่า (ถ้ามี)
        if HRP:FindFirstChild("ESPBoxObject") then HRP.ESPBoxObject:Destroy() end

        -- สร้าง BillboardGui (มองทะลุ)
        local BillGui = Instance.new("BillboardGui")
        BillGui.Name = "ESPBoxObject"
        BillGui.Adornee = HRP
        BillGui.Size = UDim2.new(4, 0, 5.5, 0)
        BillGui.AlwaysOnTop = true -- **มองทะลุกำแพง**
        BillGui.Parent = HRP
        
        -- สร้างกรอบสี่เหลี่ยม
        local BoxFrame = Instance.new("Frame")
        BoxFrame.Size = UDim2.new(1, 0, 1, 0)
        BoxFrame.BackgroundTransparency = 1
        BoxFrame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- สีฟ้า
        BoxFrame.BorderSizePixel = 2
        BoxFrame.Parent = BillGui
        
        -- **ANTI-DESTROY / RESPAWN LOOP (หัวใจสำคัญ)**
        task.spawn(function()
            while player.Character and getgenv().ESP_ACTIVE do
                -- ถ้า BillboardGui ถูก Anti-Cheat ทำลายไป
                if not HRP:FindFirstChild("ESPBoxObject") then
                    -- สร้างกล่องขึ้นมาใหม่ทันที
                    CreateBox(player) 
                    return -- จบ Loop นี้ เพราะมีการเรียกสร้างใหม่แล้ว
                end
                task.wait(1) -- เช็คทุก 1 วินาที
            end
        end)
    end
end

local function RemoveBox(player)
    if player.Character then
        local HRP = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
        if HRP and HRP:FindFirstChild("ESPBoxObject") then
            HRP.ESPBoxObject:Destroy()
        end
    end
end

-- --- 3. TOGGLE LOGIC (การเปิด/ปิด) ---
ToggleBtn.Activated:Connect(function()
    getgenv().ESP_ACTIVE = not getgenv().ESP_ACTIVE
    
    if getgenv().ESP_ACTIVE then
        ToggleBtn.Text = "DEACTIVATE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        StatusLabel.Text = "STATUS: ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- เปิด ESP ให้ผู้เล่นทุกคนในเกม
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                CreateBox(v)
            end
        end
    else
        ToggleBtn.Text = "ACTIVATE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        StatusLabel.Text = "STATUS: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        -- ลบ ESP ออกจากผู้เล่นทุกคน
        for _, v in pairs(Players:GetPlayers()) do
            RemoveBox(v)
        end
    end
end)

-- --- 4. PLAYER LISTENERS (อัปเดตคนเข้าเกม/เกิดใหม่) ---
local function SetupPlayer(player)
    player.CharacterAdded:Connect(function()
        if getgenv().ESP_ACTIVE and player ~= LocalPlayer then
            task.wait(1)
            CreateBox(player)
        end
    end)
    if getgenv().ESP_ACTIVE and player ~= LocalPlayer and player.Character then
        CreateBox(player)
    end
end

for _, v in pairs(Players:GetPlayers()) do
    SetupPlayer(v)
end
Players.PlayerAdded:Connect(SetupPlayer)

game.StarterGui:SetCore("SendNotification", {
    Title = "ESP Panel Loaded";
    Text = "Drag the panel to move. Tap ACTIVATE.";
    Duration = 5;
})
