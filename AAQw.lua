local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- สร้าง ScreenGui สำหรับ Panel
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggablePanelGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- สร้าง Frame สำหรับ Panel
local panel = Instance.new("Frame")
panel.Name = "DragPanel"
panel.Size = UDim2.new(0, 300, 0, 200)
panel.Position = UDim2.new(0.5, -150, 0.5, -100) -- กึ่งกลางจอ
panel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
panel.BorderSizePixel = 0
panel.Parent = screenGui
panel.Visible = false -- เริ่มต้นไม่แสดง

-- ทำให้มุมโค้งมน (UICorner)
local uiCorner = Instance.new("UICorner")
uiCorner.Parent = panel

-- สร้างปุ่มล็อคหัว
local lockHeadButton = Instance.new("TextButton")
lockHeadButton.Size = UDim2.new(0, 100, 0, 50)
lockHeadButton.Position = UDim2.new(0.5, -50, 0.5, -25)
lockHeadButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
lockHeadButton.Text = "Lock Head"
lockHeadButton.Parent = panel

-- ฟังก์ชันล็อคหัว
local function lockHead(targetPosition)
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local head = character:WaitForChild("Head")

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 10000
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if character and character:FindFirstChild("Head") then
            local direction = (targetPosition - head.Position).unit
            local lookAtCFrame = CFrame.new(head.Position, head.Position + direction)
            bodyGyro.CFrame = lookAtCFrame
        else
            connection:Disconnect()
            bodyGyro:Destroy()
        end
    end)
end

-- ฟังก์ชันแสดง Panel หลังจากโหลด 100%
local function showPanel()
    panel.Visible = true
    TweenService:Create(panel, TweenInfo.new(0.5), {Position = panel.Position + UDim2.new(0, 0, 0, 100)}):Play()
end

-- สร้างหน้าต่างโหลด
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 400, 0, 50)
loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -25)
loadingFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
loadingFrame.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.Text = "Loading... 0%"
loadingText.BackgroundTransparency = 1
loadingText.Parent = loadingFrame

-- ทำการโหลด
for i = 1, 100 do
    wait(0.05) -- Delay between each update
    loadingText.Text = "Loading... " .. i .. "%"
end

-- ซ่อนหน้าต่างโหลดและแสดง Panel
loadingFrame.Visible = false
showPanel()

-- ฟังก์ชันเพื่อเลื่อน Panel
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ฟังก์ชันการควบคุมเพื่อเริ่มล็อคหัว
lockHeadButton.MouseButton1Click:Connect(function()
    local targetPosition = Vector3.new(0, 10, 0) -- เปลี่ยนตำแหน่งที่ต้องการ
    lockHead(targetPosition)
end)
