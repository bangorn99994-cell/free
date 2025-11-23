-- LocalScript: StarterPlayerScripts/ClientGUI.lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local invisRemote = ReplicatedStorage:WaitForChild("InvisibleControl")

-- สร้าง ScreenGui และ ScrollingFrame (ปรับตำแหน่ง/ขนาดตามต้องการ)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolPanelGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,240,0,240)
frame.Position = UDim2.new(0,8,0.68,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 28)
title.Position = UDim2.new(0,8,0,8)
title.BackgroundTransparency = 1
title.Text = "Tool Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "Scroll"
scroll.Size = UDim2.new(1, -16, 1, -48)
scroll.Position = UDim2.new(0,8,0,44)
scroll.CanvasSize = UDim2.new(0,0,0,600) -- ปรับให้พอสำหรับปุ่มทั้งหมด
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1
scroll.Parent = frame

local uiList = Instance.new("UIListLayout")
uiList.Parent = scroll
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,8)

-- ฟังก์ชันช่วยสร้างปุ่ม
local function makeButton(text, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.LayoutOrder = layoutOrder or 1
    btn.Text = text
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.BorderSizePixel = 0
    btn.Parent = scroll
    return btn
end

-- สร้างปุ่มต่าง ๆ
local espBtn = makeButton("Toggle ESP", 1)
local invisBtn = makeButton("Toggle Invisible (Server)", 2)
local tpBtn = makeButton("Teleport to (10,5,10)", 3)
local closeBtn = makeButton("Close Panel", 99)

-- ESP Implementation (client-side Highlight only)
local espEnabled = false
local function createHighlight(character)
    if not character then return end
    if character:FindFirstChild("Highlight") then return end
    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(0,200,255)
    h.OutlineColor = Color3.fromRGB(0,0,0)
    h.Parent = character
end
local function destroyHighlight(character)
    local h = character and character:FindFirstChild("Highlight")
    if h then h:Destroy() end
end

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP ON" or "ESP OFF"
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                createHighlight(p.Character)
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            destroyHighlight(p.Character)
        end
    end
end)

-- Invisible toggle (ขอจาก server) — จะทำงานได้ก็ต่อเมื่อ server อนุญาต (isPlayerAdmin ใน server script)
local invisState = false
invisBtn.MouseButton1Click:Connect(function()
    invisState = not invisState
    -- แจ้ง server ให้เปลี่ยนสถานะจริง ๆ
    invisRemote:FireServer(invisState)
    invisBtn.Text = invisState and "Invisible ON" or "Invisible OFF"
    -- เก็บสถานะไว้ใน Attribute ของ player เพื่อให้ server เก็บถ้าต้องการ
    LocalPlayer:SetAttribute("InvisibleState", invisState)
end)

-- Teleport
tpBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(10,5,10)
    end
end)

-- Close panel
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- อัปเดตเมื่อผู้เล่นเข้ามาหรือ respawn
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        if espEnabled and p ~= LocalPlayer then
            createHighlight(c)
        end
    end)
end)
