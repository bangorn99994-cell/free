--[[
    DELTA BOX ESP (Anti-Cheat Fixed)
    - Anti-Destroy: กล่องถูกทำลาย สคริปต์จะสร้างใหม่ทันที
    - มองทะลุกำแพง 100%
    - ใช้ได้กับทุกแมพ (ไม่เช็คทีม)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().ESP = false

-- --- 1. GUI Setup (ระบบปุ่มลากได้) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "AntiDestroyESP"
-- หาที่วาง GUI ที่ปลอดภัยที่สุด (สำหรับ Delta)
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundTransparency = 1.000
MainFrame.Position = UDim2.new(0.8, -20, 0.6, 0) 
MainFrame.Size = UDim2.new(0, 70, 0, 70)

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "BOX\nFIX"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.TextSize = 16.000

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- ระบบลากปุ่ม (กันบัคปุ่มกดไม่ติด)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- --- 2. ฟังก์ชันหลักในการสร้างและรักษา ESP ---
local function AddBox(player)
    local character = player.Character
    if not character then return end
    
    -- ใช้ HumanoidRootPart เป็นจุดศูนย์กลาง
    local HRP = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    
    if HRP then
        -- ลบของเก่าทิ้ง (เพื่อให้สร้างใหม่ได้)
        if HRP:FindFirstChild("BoxFix") then HRP.BoxFix:Destroy() end

        -- สร้าง BillboardGui (มองทะลุ)
        local BillGui = Instance.new("BillboardGui")
        BillGui.Name = "BoxFix"
        BillGui.Adornee = HRP
        BillGui.Size = UDim2.new(4, 0, 5.5, 0)
        BillGui.AlwaysOnTop = true -- **หัวใจของการมองทะลุกำแพง**
        BillGui.Parent = HRP
        
        -- สร้างกรอบสี่เหลี่ยม
        local BoxFrame = Instance.new("Frame")
        BoxFrame.Size = UDim2.new(1, 0, 1, 0)
        BoxFrame.BackgroundTransparency = 1
        BoxFrame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- สีฟ้า
        BoxFrame.BorderSizePixel = 2
        BoxFrame.Parent = BillGui
        
        -- 3. **Anti-Destroy Loop**
        -- รันใน Coroutine เพื่อไม่ให้บล็อคโค้ดส่วนอื่น
        task.spawn(function()
            while player.Character and getgenv().ESP do
                -- ถ้า BillGui หายไป (ถูก Anti-Cheat ทำลาย)
                if not HRP:FindFirstChild("BoxFix") then
                    -- เรียก AddBox เพื่อสร้างใหม่ทันที
                    AddBox(player)
                    return -- จบ Loop นี้ เพราะ AddBox จะสร้าง BillGui ใหม่
                end
                task.wait(1) -- เช็คทุก 1 วินาที
            end
        end)
    end
end

local function RemoveBox(player)
    if player.Character then
        local HRP = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
        if HRP and HRP:FindFirstChild("BoxFix") then
            HRP.BoxFix:Destroy()
        end
    end
end

-- --- 3. ระบบควบคุมการเปิด/ปิด ---
ToggleBtn.Activated:Connect(function()
    if dragging and (UserInputService:GetMouseLocation() - Vector2.new(dragStart.X, dragStart.Y)).Magnitude > 10 then return end

    getgenv().ESP = not getgenv().ESP
    
    if getgenv().ESP then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        UIStroke.Color = Color3.fromRGB(0, 255, 0)
        
        -- ใส่กล่องให้ทุกคนที่อยู่ในเกมแล้ว
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                AddBox(v)
            end
        end
    else
        ToggleBtn.Text = "BOX\nFIX"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        UIStroke.Color = Color3.fromRGB(255, 0, 0)
        
        for _, v in pairs(Players:GetPlayers()) do
            RemoveBox(v)
        end
    end
end)

-- --- 4. ระบบอัปเดตคนเข้าเกม/เกิดใหม่ ---
local function SetupPlayer(player)
    player.CharacterAdded:Connect(function()
        if getgenv().ESP and player ~= LocalPlayer then
            task.wait(1) -- รอนิดหน่อยให้ตัวละครโหลดเสร็จ
            AddBox(player)
        end
    end)
    if getgenv().ESP and player ~= LocalPlayer and player.Character then
        AddBox(player)
    end
end

-- โหลดคนที่มีอยู่แล้ว
for _, v in pairs(Players:GetPlayers()) do
    SetupPlayer(v)
end
-- โหลดคนที่จะเข้ามาใหม่
Players.PlayerAdded:Connect(SetupPlayer)

game.StarterGui:SetCore("SendNotification", {
    Title = "ESP Anti-Cheat Loaded";
    Text = "Box will respawn if destroyed (Press button)";
    Duration = 5;
})
