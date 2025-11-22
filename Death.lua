--[[
    DELTA UNIVERSAL ESP (Fixed)
    - โชว์ทุกคน (แก้ปัญหาแมพที่ไม่มีระบบทีม)
    - ใช้ได้กับทุกแมพ (R6/R15)
    - รองรับ Delta Mobile
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

getgenv().UniversalESP = false

-- --- 1. สร้างปุ่ม GUI (ลากได้) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "UniversalESP"
-- หาที่วาง GUI ที่ปลอดภัยสำหรับ Delta
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
MainFrame.Position = UDim2.new(0.8, -20, 0.6, 0) 
MainFrame.Size = UDim2.new(0, 70, 0, 70)

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "SEE\nALL"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.TextSize = 16.000
ToggleBtn.AutoButtonColor = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

UIStroke.Parent = ToggleBtn
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 0, 0)

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

-- --- 2. ฟังก์ชันสร้างกล่อง (The Fix) ---
local function AddBox(player)
    -- รอให้ตัวละครโหลด
    if not player.Character then return end
    
    -- หาจุดกึ่งกลางตัว (รองรับทั้ง R6 และ R15)
    local HRP = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
    
    if HRP then
        -- ลบอันเก่าทิ้งก่อนกันซ้อน
        if HRP:FindFirstChild("UniversalBox") then HRP.UniversalBox:Destroy() end

        local BillGui = Instance.new("BillboardGui")
        BillGui.Name = "UniversalBox"
        BillGui.Adornee = HRP
        BillGui.Size = UDim2.new(4, 0, 5.5, 0)
        BillGui.AlwaysOnTop = true -- **มองทะลุกำแพง**
        BillGui.Parent = HRP

        local BoxFrame = Instance.new("Frame")
        BoxFrame.Size = UDim2.new(1, 0, 1, 0)
        BoxFrame.BackgroundTransparency = 1
        BoxFrame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- สีแดง
        BoxFrame.BorderSizePixel = 2
        BoxFrame.Parent = BillGui
        
        -- เพิ่มชื่อ (Name Tag) เพื่อความชัวร์ว่าเห็น
        local NameTag = Instance.new("TextLabel")
        NameTag.Parent = BillGui
        NameTag.Position = UDim2.new(0, 0, -0.2, 0)
        NameTag.Size = UDim2.new(1, 0, 0.2, 0)
        NameTag.BackgroundTransparency = 1
        NameTag.Text = player.Name
        NameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameTag.TextStrokeTransparency = 0
        NameTag.TextSize = 10
    end
end

local function RemoveBox(player)
    if player.Character then
        local HRP = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
        if HRP and HRP:FindFirstChild("UniversalBox") then
            HRP.UniversalBox:Destroy()
        end
    end
end

-- --- 3. ระบบทำงาน ---
ToggleBtn.Activated:Connect(function()
    if dragging and (UserInputService:GetMouseLocation() - Vector2.new(dragStart.X, dragStart.Y)).Magnitude > 10 then return end

    getgenv().UniversalESP = not getgenv().UniversalESP
    
    if getgenv().UniversalESP then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Loop ใส่ทุกคน (ยกเว้นตัวเอง)
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                AddBox(v)
            end
        end
    else
        ToggleBtn.Text = "SEE\nALL"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        for _, v in pairs(Players:GetPlayers()) do
            RemoveBox(v)
        end
    end
end)

-- ออโต้โหลดเมื่อมีคนเกิดใหม่
Players.PlayerAdded:Connect(function(v)
    v.CharacterAdded:Connect(function()
        if getgenv().UniversalESP and v ~= LocalPlayer then
            task.wait(1)
            AddBox(v)
        end
    end)
end)

-- โหลดใส่คนที่อยู่ในเกมแล้วเมื่อตายแล้วเกิดใหม่
for _, v in pairs(Players:GetPlayers()) do
    v.CharacterAdded:Connect(function()
        if getgenv().UniversalESP and v ~= LocalPlayer then
            task.wait(1)
            AddBox(v)
        end
    end)
end

game.StarterGui:SetCore("SendNotification", {
    Title = "Universal ESP Fixed";
    Text = "Now shows ALL players (No Team Check)";
    Duration = 5;
})
