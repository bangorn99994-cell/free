--[[ 
    DELTA BOX ESP (Mobile Optimized)
    - สร้างกรอบสี่เหลี่ยมรอบตัวศัตรู
    - มองทะลุกำแพง (Always On Top)
    - มีเส้นบอกเลือด (Health Bar)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

getgenv().ESP = false

-- --- 1. สร้างปุ่ม GUI (แบบเดิมที่ใช้งานได้ดี) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "BoxESPGui"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1.000
MainFrame.Position = UDim2.new(0.8, -20, 0.55, 0) -- อยู่ต่ำลงมาจากปุ่มล็อคเดิมหน่อย
MainFrame.Size = UDim2.new(0, 70, 0, 70)

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ESP\nBOX"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255) -- สีฟ้า
ToggleBtn.TextSize = 16.000
ToggleBtn.AutoButtonColor = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(0, 255, 255)

-- ระบบลากปุ่ม
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

-- --- 2. ฟังก์ชันสร้าง ESP ---
local function CreateESP(player)
    -- เช็คว่ามี ESP เดิมอยู่ไหม ถ้ามีให้ลบออกก่อน
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character.HumanoidRootPart:FindFirstChild("BoxESP") then
            player.Character.HumanoidRootPart.BoxESP:Destroy()
        end

        -- สร้าง BillboardGui (ตัวป้ายที่ลอยเหนือหัว)
        local espBox = Instance.new("BillboardGui")
        espBox.Name = "BoxESP"
        espBox.Adornee = player.Character.HumanoidRootPart
        espBox.Size = UDim2.new(4, 0, 5.5, 0) -- ขนาดกรอบ (กว้าง x สูง)
        espBox.AlwaysOnTop = true -- **หัวใจสำคัญ: ทำให้มองทะลุกำแพง**
        espBox.Parent = player.Character.HumanoidRootPart

        -- สร้างกรอบสี่เหลี่ยม (Frame)
        local border = Instance.new("Frame")
        border.Size = UDim2.new(1, 0, 1, 0)
        border.Position = UDim2.new(0, 0, 0, -0.5) -- จัดตำแหน่งให้พอดีตัว
        border.BackgroundTransparency = 1 -- พื้นหลังใส
        border.BorderColor3 = Color3.fromRGB(255, 0, 0) -- สีเส้น (แดง)
        border.BorderSizePixel = 2 -- ความหนาเส้น
        border.Parent = espBox

        -- (แถม) หลอดเลือด
        local hpBar = Instance.new("Frame")
        hpBar.Size = UDim2.new(0.05, 0, 1, 0) -- หลอดแนวตั้ง
        hpBar.Position = UDim2.new(-0.1, 0, 0, -0.5)
        hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- สีเขียว
        hpBar.BorderSizePixel = 0
        hpBar.Parent = espBox
        
        -- อัปเดตหลอดเลือดเรื่อยๆ
        task.spawn(function()
            while player.Character and player.Character:FindFirstChild("Humanoid") and espBox.Parent do
                local hum = player.Character.Humanoid
                hpBar.Size = UDim2.new(0.05, 0, (hum.Health / hum.MaxHealth), 0)
                hpBar.Position = UDim2.new(-0.1, 0, (1 - (hum.Health / hum.MaxHealth)) - 0.5, 0)
                
                -- เปลี่ยนสีตามเลือด
                if hum.Health < 30 then
                    hpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                else
                    hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                end
                task.wait(0.1)
            end
        end)
    end
end

local function RemoveESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChild("BoxESP") then
        player.Character.HumanoidRootPart.BoxESP:Destroy()
    end
end

-- --- 3. ระบบควบคุมหลัก ---

-- ปุ่มเปิด/ปิด
ToggleBtn.Activated:Connect(function()
    if dragging and (UserInputService:GetMouseLocation() - Vector2.new(dragStart.X, dragStart.Y)).Magnitude > 10 then return end

    getgenv().ESP = not getgenv().ESP
    
    if getgenv().ESP then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        -- เริ่มทำงานทันที
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team then
                CreateESP(v)
            end
        end
    else
        ToggleBtn.Text = "ESP\nBOX"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        
        -- ลบออกทันที
        for _, v in pairs(Players:GetPlayers()) do
            RemoveESP(v)
        end
    end
end)

-- อัปเดตเมื่อมีคนเกิดใหม่ หรือคนเข้าเกม
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if getgenv().ESP and player.Team ~= LocalPlayer.Team then
            task.wait(1) -- รอโหลดตัวแปปนึง
            CreateESP(player)
        end
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if getgenv().ESP and player.Team ~= LocalPlayer.Team then
            task.wait(1)
            CreateESP(player)
        end
    end)
end

-- แจ้งเตือน
game.StarterGui:SetCore("SendNotification", {
    Title = "Box ESP Loaded";
    Text = "Tap button to see through walls!";
    Duration = 3;
})

