--[[
    DELTA WARHACK - BOX ESP (Drawing Library)
    - ใช้ Drawing Library เพื่อวาดทับหน้าจอ (Anti-Anti-Cheat)
    - มองทะลุกำแพง 100%
    - มีปุ่มเปิด/ปิด (GUI Panel)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Drawing = getgenv().Drawing -- เข้าถึง Drawing Library ของ Executor

getgenv().WarHackActive = false
local ESP_Objects = {} -- ตารางเก็บวัตถุวาด (Drawing Objects)

-- เช็คว่า Executor รองรับ Drawing Library หรือไม่
if not Drawing then
    game.StarterGui:SetCore("SendNotification", {
        Title = "ERROR";
        Text = "Executor ไม่รองรับ Drawing Library (ไม่สามารถรัน Warhack ได้)";
        Duration = 10;
    })
    return -- หยุดการทำงาน
end


-- --- 1. GUI PANEL SETUP (หน้าต่างเมนู) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
-- โค้ดส่วน GUI ที่คุณเคยได้ไปก่อนหน้านี้... (ถูกปรับให้สั้นลง)
-- (การปรับแต่ง UI/ระบบลากเพื่อความเสถียรเหมือนเดิม)

ScreenGui.Name = "DrawingESPanel"
if getgenv and getgenv().gethui then
    ScreenGui.Parent = getgenv().gethui()
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

MainFrame.Name = "ESP_Panel"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 150, 0, 80)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "WAR HACK"
TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.TextSize = 15.000

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.45, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "DEACTIVATED"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14.000

-- (โค้ดลาก Panel ถูกละไว้เพื่อความกระชับ)

-- --- 2. CORE DRAWING LOGIC (การวาดภาพ) ---

local function ClearDrawings()
    for _, obj in pairs(ESP_Objects) do
        obj.Visible = false
        obj:Remove()
    end
    ESP_Objects = {}
end

local function CreateBoxDrawing(Position, Size, Color)
    local Box = Drawing.new("Quad")
    Box.Visible = true
    Box.Thickness = 2
    Box.Filled = false
    Box.Color = Color
    -- Quad (กรอบ) ต้องใช้ 4 จุดในการวาดสี่เหลี่ยม
    Box.PointA = Vector2.new(Position.X - Size.X, Position.Y - Size.Y)
    Box.PointB = Vector2.new(Position.X + Size.X, Position.Y - Size.Y)
    Box.PointC = Vector2.new(Position.X + Size.X, Position.Y + Size.Y)
    Box.PointD = Vector2.new(Position.X - Size.X, Position.Y + Size.Y)
    table.insert(ESP_Objects, Box)
    return Box
end

-- ลูปวาดภาพ (ทำงานทุกเฟรม)
RunService.RenderStepped:Connect(function()
    if not getgenv().WarHackActive then
        ClearDrawings()
        return
    end

    ClearDrawings() -- ลบของเก่าทิ้งก่อนวาดใหม่

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            
            -- เช็คทีม (จะไม่มองเห็นเพื่อน)
            if player.Team ~= nil and LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team then
                continue
            end
            
            local HRP = player.Character.HumanoidRootPart
            local Head = player.Character:FindFirstChild("Head")
            
            if Head then
                -- หาจุดบนหน้าจอของเท้า (ล่าง) และหัว (บน)
                local HeadPos, OnScreenH = Camera:WorldToViewportPoint(Head.Position)
                local FootPos, OnScreenF = Camera:WorldToViewportPoint(HRP.Position - Vector3.new(0, 2.5, 0)) -- ใต้เท้า
                
                if OnScreenH or OnScreenF then
                    local HeadY = HeadPos.Y
                    local FootY = FootPos.Y
                    local Height = math.abs(FootY - HeadY)
                    local Width = Height / 2.5 -- กำหนดความกว้างตามสัดส่วน
                    local CenterX = HeadPos.X
                    local CenterY = HeadY + (Height / 2)

                    -- วาดกรอบสี่เหลี่ยม (Box)
                    -- เราต้องคำนวณ 4 จุดมุมสำหรับ Quad
                    local X1 = CenterX - Width / 2
                    local X2 = CenterX + Width / 2
                    local Y1 = FootY
                    local Y2 = HeadY

                    local Box = Drawing.new("Quad")
                    Box.Visible = true
                    Box.Thickness = 1.5
                    Box.Filled = false
                    Box.Color = Color3.new(1, 0, 0) -- สีแดง
                    Box.PointA = Vector2.new(X1, Y1)
                    Box.PointB = Vector2.new(X2, Y1)
                    Box.PointC = Vector2.new(X2, Y2)
                    Box.PointD = Vector2.new(X1, Y2)
                    table.insert(ESP_Objects, Box)
                    
                    -- (แถม) วาดชื่อผู้เล่น
                    local NameTag = Drawing.new("Text")
                    NameTag.Visible = true
                    NameTag.Text = player.Name
                    NameTag.Position = Vector2.new(CenterX, HeadY - 15)
                    NameTag.Color = Color3.new(1, 1, 1) -- สีขาว
                    NameTag.Size = 14
                    table.insert(ESP_Objects, NameTag)
                end
            end
        end
    end
end)

-- --- 3. TOGGLE LOGIC (การเปิด/ปิด) ---
ToggleBtn.Activated:Connect(function()
    getgenv().WarHackActive = not getgenv().WarHackActive
    
    if getgenv().WarHackActive then
        ToggleBtn.Text = "ACTIVE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleBtn.Text = "DEACTIVATED"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ClearDrawings()
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Warhack Loaded";
    Text = "Drawing Library ESP is now active. Tap to toggle.";
    Duration = 5;
})
