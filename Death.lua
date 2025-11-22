--[[
    DELTA WAR HACK (AGGRESSIVE BOX ESP FIX)
    - ใช้โครงสร้างที่ทำงานได้ (pcall, coroutine.wrap, Heartbeat)
    - สร้างและบังคับให้กรอบบล็อก (BillboardGui) แสดงผลตลอดเวลา
    - ใช้ปุ่ม Toggle ที่เรียบง่าย
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

getgenv().ESP_ACTIVE = false
local BOX_COLOR = Color3.fromRGB(255, 255, 0) -- สีเหลือง

-- --- 1. SIMPLE GUI TOGGLE ---
-- (ใช้โครงสร้าง GUI เดียวกับโค้ด Chams ตัวสุดท้ายที่ทำงานได้)
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "AggressiveBoxToggle"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

ToggleBtn.Name = "ToggleBoxESP"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 150, 0, 50)
ToggleBtn.Position = UDim2.new(0.01, 0, 0.85, 0) 
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "BOX OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18


-- --- 2. CORE BOX ESP LOGIC (พร้อม Anti-Destroy Loop) ---

local function CreateBox(character)
    local HRP = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not HRP then return end
    
    -- สร้าง BillboardGui (มองทะลุ)
    local BillGui = Instance.new("BillboardGui")
    BillGui.Name = "AGGR_BOX_ESP"
    BillGui.Adornee = HRP
    BillGui.Size = UDim2.new(4, 0, 5.5, 0)
    BillGui.AlwaysOnTop = true -- **การมองทะลุกำแพง**
    BillGui.Parent = HRP
    
    -- สร้างกรอบสี่เหลี่ยม (Frame)
    local BoxFrame = Instance.new("Frame")
    BoxFrame.Name = "BoxFrame"
    BoxFrame.Size = UDim2.new(1, 0, 1, 0)
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.BorderColor3 = BOX_COLOR
    BoxFrame.BorderSizePixel = 2
    BoxFrame.Parent = BillGui
    
    return BillGui -- ส่งวัตถุที่สร้างกลับไป
end

local function HandlePlayer(player)
    local function ReapplyLoop(character)
        local CurrentBox = character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart:FindFirstChild("AGGR_BOX_ESP")
        
        while getgenv().ESP_ACTIVE and character and character.Parent do
            pcall(function()
                -- ** ANTI-DESTROY CHECK (หัวใจสำคัญ)**
                if not CurrentBox or not CurrentBox.Parent then
                    -- ถ้า Anti-Cheat ลบกล่องไป ให้สร้างใหม่ทันที!
                    CurrentBox = CreateBox(character)
                end

                -- ถ้ากล่องอยู่ ให้มั่นใจว่า AlwaysOnTop ยังทำงานอยู่
                if CurrentBox then
                    CurrentBox.AlwaysOnTop = true
                    -- ในกรณีที่ Anti-Cheat แก้ไขสีหรือขนาด เราก็ set ซ้ำ
                    CurrentBox.Size = UDim2.new(4, 0, 5.5, 0)
                    CurrentBox.Adornee = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                end
            end)
            
            RunService.Heartbeat:Wait() -- วนลูปด้วยความถี่สูงสุด
        end
        
        -- เมื่อลูปหยุดทำงาน ให้ลบ Box ออกอย่างปลอดภัย
        pcall(function()
            if character then
                local boxToRemove = character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart:FindFirstChild("AGGR_BOX_ESP")
                if boxToRemove then boxToRemove:Destroy() end
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
        ToggleBtn.Text = "BOX ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and (v.Team == nil or v.Team ~= LocalPlayer.Team) then
                HandlePlayer(v)
            end
        end
    else
        ToggleBtn.Text = "BOX OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        -- ทำลายกล่องทั้งหมดทันทีเมื่อปิด
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    v.Character.HumanoidRootPart:FindFirstChild("AGGR_BOX_ESP"):Destroy()
                end)
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
    Title = "Aggressive Box ESP Loaded";
    Text = "Box ESP Anti-Destroy Loop ถูกเปิดใช้งานแล้ว.";
    Duration = 5;
})
