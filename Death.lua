--[[
    DELTA WAR HACK CHAMS (Ultimate Anti-Crash / Safe Call)
    - ใช้ pcall และ coroutine เพื่อความเสถียรสูงสุด
    - แก้ไขตัวละครให้เรืองแสงมองทะลุ (Chams X-Ray)
    - วนลูปการทำงานด้วยความถี่สูงเพื่อต่อสู้กับ Anti-Cheat
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

getgenv().CHAMS_ACTIVE = false
local CHAMS_COLOR = Color3.fromRGB(0, 255, 255) -- สีฟ้านีออน (มองง่าย)

-- --- 1. GUI PANEL SETUP ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local TitleLabel = Instance.new("TextLabel")

ScreenGui.Name = "FinalChamsHackPanel"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- กรอบเมนูหลัก
MainFrame.Name = "Chams_Panel_Final"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderColor3 = CHAMS_COLOR
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 150, 0, 80)

-- หัวข้อ
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = CHAMS_COLOR
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "ULTIMATE CHAMS"
TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.TextSize = 14.000

-- ปุ่มเปิด/ปิด
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.45, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "DEACTIVATED"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14.000

-- (ระบบลาก Panel ถูกเพิ่มไว้ตรงนี้เพื่อให้ใช้งานบนมือถือได้)
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

-- --- 2. CORE CHAMS LOGIC (พร้อม pcall) ---

local function ApplyChams_Safe(part)
    if not part:IsA("BasePart") and not part:IsA("MeshPart") then return end
    
    -- ใช้ pcall เพื่อป้องกันไม่ให้โค้ดพัง หาก Anti-Cheat ลบวัตถุในขณะที่เรากำลังเปลี่ยนคุณสมบัติ
    pcall(function()
        -- ตั้งค่า Material และสีเพื่อการเรืองแสง
        part.Material = Enum.Material.Neon 
        part.Color = CHAMS_COLOR
        part.Transparency = 0.5 -- โปร่งแสงเล็กน้อย

        -- สร้าง Highlight เพื่อการมองทะลุ
        local h = part:FindFirstChild("Highlight") or Instance.new("Highlight")
        h.FillTransparency = 0 -- ทำให้เห็นตัวละครเต็มๆ
        h.DepthMode = Enum.DepthMode.AlwaysOnTop -- **หัวใจของการมองทะลุกำแพง**
        h.FillColor = CHAMS_COLOR
        h.Parent = part
        h.Enabled = true
    end)
end

local function RemoveChams_Safe(part)
    if not part:IsA("BasePart") and not part:IsA("MeshPart") then return end
    
    pcall(function()
        part.Material = Enum.Material.Plastic -- คืนค่าเดิม
        part.Transparency = 0
        local h = part:FindFirstChild("Highlight")
        if h then
            h.Enabled = false
            h:Destroy()
        end
    end)
end

local function HandlePlayer(player)
    local function ReapplyLoop(character)
        -- ลูปนี้จะทำงานอย่างต่อเนื่องและไม่หยุดง่าย ๆ
        while getgenv().CHAMS_ACTIVE and character and character.Parent do
            -- ใช้ pcall เพื่อให้สแกนต่อไปได้ แม้จะมีข้อผิดพลาดกับ Part บางชิ้น
            pcall(function()
                for _, part in pairs(character:GetDescendants()) do
                    ApplyChams_Safe(part)
                end
            end)
            RunService.Heartbeat:Wait() -- วนลูปด้วยความถี่สูงสุด (60+ ครั้ง/วินาที)
        end
    end
    
    -- เมื่อตัวละครเกิดใหม่ ให้รันลูปใหม่ทันที
    player.CharacterAdded:Connect(function(character)
        if getgenv().CHAMS_ACTIVE then
            coroutine.wrap(ReapplyLoop)(character)
        end
    end)
    
    -- ถ้าเปิดอยู่และตัวละครมีอยู่แล้ว ให้เริ่มลูป
    if player.Character and getgenv().CHAMS_ACTIVE then
        coroutine.wrap(ReapplyLoop)(player.Character)
    end
end

-- --- 3. TOGGLE LOGIC (การเปิด/ปิด) ---
ToggleBtn.Activated:Connect(function()
    getgenv().CHAMS_ACTIVE = not getgenv().CHAMS_ACTIVE
    
    if getgenv().CHAMS_ACTIVE then
        ToggleBtn.Text = "ACTIVE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and (v.Team == nil or v.Team ~= LocalPlayer.Team) then
                HandlePlayer(v)
            end
        end
    else
        ToggleBtn.Text = "DEACTIVATED"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                for _, part in pairs(v.Character:GetDescendants()) do
                    RemoveChams_Safe(part)
                end
            end
        end
    end
end)

-- --- 4. INITIAL SETUP (เตรียมพร้อม) ---
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
    Title = "Ultimate Chams Loaded";
    Text = "โค้ดนี้ใช้เทคนิค pcall และ Coroutine เพื่อความเสถียรสูงสุด";
    Duration = 5;
})
